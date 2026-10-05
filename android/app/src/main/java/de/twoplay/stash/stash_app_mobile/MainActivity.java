package de.twoplay.stash.stash_app_mobile;

import android.view.WindowManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

// FlutterFragmentActivity: required by local_auth for biometric prompts.
public class MainActivity extends FlutterFragmentActivity {
    private static final String PRIVACY_CHANNEL = "stash/privacy";

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
    }
}
