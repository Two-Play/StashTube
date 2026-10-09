package io.github.two_play.stashappmobile;

import android.app.PictureInPictureParams;
import android.content.ComponentName;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.os.Build;
import android.util.Rational;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.ryanheise.audioservice.AudioServiceFragmentActivity;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

// A FlutterFragmentActivity (required by local_auth for biometric prompts)
// that shares its engine with audio_service's media notification (4.12).
public class MainActivity extends AudioServiceFragmentActivity {
    private static final String PRIVACY_CHANNEL = "stash/privacy";
    private static final String APP_ICON_CHANNEL = "stash/appicon";
    private static final String PIP_CHANNEL = "stash/pip";
    // activity-alias names in AndroidManifest.xml.
    private static final String[] ICON_ALIASES = {"DefaultIcon", "NotesIcon", "CalculatorIcon"};

    private MethodChannel pipChannel;
    // Enter picture-in-picture when the user leaves the app (a video plays).
    private boolean autoPip = false;
    private Rational pipAspect = new Rational(16, 9);

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        // "Hide in app switcher": FLAG_SECURE blanks the recents thumbnail
        // (and blocks screenshots).
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), PRIVACY_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if ("setSecure".equals(call.method)) {
                        boolean secure = Boolean.TRUE.equals(call.arguments);
                        runOnUiThread(() -> {
                            if (secure) {
                                getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
                            } else {
                                getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
                            }
                        });
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                });

        // Disguised app icons (11.3): enable the chosen launcher alias first,
        // then disable the others, so there is always a launcher entry.
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), APP_ICON_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (!"setIcon".equals(call.method)) {
                        result.notImplemented();
                        return;
                    }
                    String chosen = call.arguments();
                    boolean known = false;
                    for (String alias : ICON_ALIASES) known |= alias.equals(chosen);
                    if (!known) {
                        result.error("unknown_icon", "Unknown icon " + chosen, null);
                        return;
                    }
                    PackageManager pm = getPackageManager();
                    String base = MainActivity.class.getPackage().getName() + ".";
                    pm.setComponentEnabledSetting(new ComponentName(this, base + chosen),
                            PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP);
                    for (String alias : ICON_ALIASES) {
                        if (alias.equals(chosen)) continue;
                        pm.setComponentEnabledSetting(new ComponentName(this, base + alias),
                                PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP);
                    }
                    result.success(null);
                });

        // Picture-in-picture (4.12): "setAutoEnter" {enabled, aspect} while a
        // video plays, "enter" {aspect} from the player's button. Reports
        // "pipChanged" (bool) back to Dart, which then shows only the video.
        pipChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), PIP_CHANNEL);
        pipChannel.setMethodCallHandler((call, result) -> {
            Double aspect = call.argument("aspect");
            if (aspect != null) pipAspect = toRational(aspect);
            switch (call.method) {
                case "setAutoEnter":
                    autoPip = Boolean.TRUE.equals(call.argument("enabled")) && pipSupported();
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && pipSupported()) {
                        setPictureInPictureParams(pipParams());
                    }
                    result.success(null);
                    break;
                case "enter":
                    result.success(enterPip());
                    break;
                default:
                    result.notImplemented();
            }
        });
    }

    private boolean pipSupported() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
                && getPackageManager().hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE);
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private PictureInPictureParams pipParams() {
        PictureInPictureParams.Builder builder = new PictureInPictureParams.Builder().setAspectRatio(pipAspect);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android 12+ enters by itself, with a smooth animation.
            builder.setAutoEnterEnabled(autoPip).setSeamlessResizeEnabled(false);
        }
        return builder.build();
    }

    private boolean enterPip() {
        if (!pipSupported()) return false;
        try {
            return enterPictureInPictureMode(pipParams());
        } catch (IllegalStateException e) {
            return false;
        }
    }

    // Android allows aspect ratios between 1:2.39 and 2.39:1; Dart clamps too.
    private static Rational toRational(double aspect) {
        double clamped = Math.max(0.42, Math.min(2.38, aspect));
        return new Rational((int) Math.round(clamped * 10000), 10000);
    }

    @Override
    public void onUserLeaveHint() {
        super.onUserLeaveHint();
        // Before Android 12 the app enters picture-in-picture itself.
        if (autoPip && Build.VERSION.SDK_INT < Build.VERSION_CODES.S) enterPip();
    }

    @Override
    public void onPictureInPictureModeChanged(boolean isInPictureInPictureMode, @NonNull Configuration newConfig) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig);
        if (pipChannel != null) pipChannel.invokeMethod("pipChanged", isInPictureInPictureMode);
    }
}
