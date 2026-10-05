package de.twoplay.stash.stash_app_mobile;

import android.content.ComponentName;
import android.content.pm.PackageManager;
import android.view.WindowManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

// FlutterFragmentActivity: required by local_auth for biometric prompts.
public class MainActivity extends FlutterFragmentActivity {
    private static final String PRIVACY_CHANNEL = "stash/privacy";
    private static final String APP_ICON_CHANNEL = "stash/appicon";
    // activity-alias names in AndroidManifest.xml.
    private static final String[] ICON_ALIASES = {"DefaultIcon", "NotesIcon", "CalculatorIcon"};

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
    }
}
