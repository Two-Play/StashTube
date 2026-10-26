package io.github.two_play.stashappmobile;

import android.app.PictureInPictureParams;
import android.content.ComponentName;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.Rect;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Rational;
import android.view.OrientationEventListener;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.ryanheise.audioservice.AudioServiceFragmentActivity;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.List;

// A FlutterFragmentActivity (required by local_auth for biometric prompts)
// that shares its engine with audio_service's media notification (4.12).
public class MainActivity extends AudioServiceFragmentActivity {
    private static final String PRIVACY_CHANNEL = "stash/privacy";
    private static final String APP_ICON_CHANNEL = "stash/appicon";
    private static final String PIP_CHANNEL = "stash/pip";
    private static final String ORIENTATION_CHANNEL = "stash/device_orientation";
    // activity-alias names in AndroidManifest.xml.
    private static final String[] ICON_ALIASES = {"DefaultIcon", "NotesIcon", "CalculatorIcon"};

    private MethodChannel pipChannel;
    // Enter picture-in-picture when the user leaves the app (a video plays).
    private boolean autoPip = false;
    private Rational pipAspect = new Rational(16, 9);
    private OrientationEventListener orientationListener;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Phones turn only for the player's fullscreen (4.28), whose video
        // already lies turned when the screen turns: Android's rotation
        // animation would turn that picture once more. A crossfade keeps the
        // old picture where it is until the new one is drawn (a cut showed
        // the old frame stretched to the new window for a moment), and both
        // look the same. Tablets keep the animation.
        if (getResources().getConfiguration().smallestScreenWidthDp < 600) {
            WindowManager.LayoutParams params = getWindow().getAttributes();
            params.rotationAnimation = WindowManager.LayoutParams.ROTATION_ANIMATION_CROSSFADE;
            getWindow().setAttributes(params);
        }
    }

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

        // How the phone is held (4.19): "portrait", "turnedLeft" (top to the
        // left) or "turnedRight" whenever that changes. The app stays portrait on phones, so the player
        // learns here that the phone was turned. With the system's rotation
        // lock on, landscape isn't reported (portrait still is, to leave a
        // fullscreen entered before). Gaps between the ranges keep a phone
        // held at an angle from flipping back and forth; flat reports nothing.
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), ORIENTATION_CHANNEL)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    private String last;

                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        last = null;
                        orientationListener = new OrientationEventListener(MainActivity.this, SensorManager.SENSOR_DELAY_UI) {
                            @Override
                            public void onOrientationChanged(int degrees) {
                                if (degrees == ORIENTATION_UNKNOWN) return;
                                // 90: the left side is up, i.e. the top points right.
                                String held;
                                if (degrees >= 60 && degrees <= 120) {
                                    held = "turnedRight";
                                } else if (degrees >= 240 && degrees <= 300) {
                                    held = "turnedLeft";
                                } else if (degrees <= 30 || degrees >= 330 || (degrees >= 150 && degrees <= 210)) {
                                    held = "portrait";
                                } else {
                                    return;
                                }
                                if (held.equals(last)) return;
                                if (!"portrait".equals(held) && !autoRotate()) return;
                                last = held;
                                events.success(held);
                            }
                        };
                        if (orientationListener.canDetectOrientation()) orientationListener.enable();
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        if (orientationListener != null) orientationListener.disable();
                        orientationListener = null;
                    }
                });

        // Picture-in-picture (4.12): "setAutoEnter" {enabled, aspect} while a
        // video plays and whenever its size becomes known or changes, "enter"
        // {aspect, rect?} from the player's button (rect: the video on screen
        // in physical pixels, [x, y, w, h]). Reports "pipChanged" (bool) back
        // to Dart, which then shows only the video.
        pipChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), PIP_CHANNEL);
        pipChannel.setMethodCallHandler((call, result) -> {
            Double aspect = call.argument("aspect");
            if (aspect != null) pipAspect = toRational(aspect);
            switch (call.method) {
                case "setAutoEnter":
                    autoPip = Boolean.TRUE.equals(call.argument("enabled")) && pipSupported();
                    // Also while in picture-in-picture: the window takes the
                    // new shape (the next video of a queue, the decoded size).
                    if (pipSupported()) {
                        try {
                            setPictureInPictureParams(pipParams(null));
                        } catch (IllegalArgumentException | IllegalStateException e) {
                            // An aspect Android refuses; keep the last parameters.
                        }
                    }
                    result.success(null);
                    break;
                case "enter":
                    result.success(enterPip(sourceRect(call)));
                    break;
                default:
                    result.notImplemented();
            }
        });
    }

    /** Whether the system may turn apps (its rotation lock is off). */
    private boolean autoRotate() {
        return Settings.System.getInt(getContentResolver(), Settings.System.ACCELEROMETER_ROTATION, 0) == 1;
    }

    private boolean pipSupported() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
                && getPackageManager().hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE);
    }

    // The video's place on screen, which the window shrinks out of; only for
    // the button, since for auto-enter the player may have moved since.
    @Nullable
    private static Rect sourceRect(MethodCall call) {
        List<Number> rect = call.argument("rect");
        if (rect == null || rect.size() != 4) return null;
        int left = rect.get(0).intValue();
        int top = rect.get(1).intValue();
        int width = rect.get(2).intValue();
        int height = rect.get(3).intValue();
        if (width <= 0 || height <= 0) return null;
        return new Rect(left, top, left + width, top + height);
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private PictureInPictureParams pipParams(@Nullable Rect sourceRect) {
        PictureInPictureParams.Builder builder = new PictureInPictureParams.Builder().setAspectRatio(pipAspect);
        if (sourceRect != null) builder.setSourceRectHint(sourceRect);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android 12+ enters by itself, with a smooth animation.
            builder.setAutoEnterEnabled(autoPip).setSeamlessResizeEnabled(false);
        }
        return builder.build();
    }

    private boolean enterPip(@Nullable Rect sourceRect) {
        if (!pipSupported()) return false;
        try {
            return enterPictureInPictureMode(pipParams(sourceRect));
        } catch (IllegalArgumentException | IllegalStateException e) {
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
        if (autoPip && Build.VERSION.SDK_INT < Build.VERSION_CODES.S) enterPip(null);
    }

    @Override
    public void onPictureInPictureModeChanged(boolean isInPictureInPictureMode, @NonNull Configuration newConfig) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig);
        if (pipChannel != null) pipChannel.invokeMethod("pipChanged", isInPictureInPictureMode);
    }
}
