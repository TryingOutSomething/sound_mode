package com.tryingoutsomething.soundmode.sound_mode;

import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.os.Build;
import android.provider.Settings;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static android.content.Context.NOTIFICATION_SERVICE;

/**
 * SoundModePlugin
 */
public class SoundModePlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private static AudioManager audioManager;
    private static NotificationManager notificationManager;
    private static Context context;

    private final String NORMAL_MODE_PROFILE = "Normal Mode";
    private final String VIBRATE_MODE_PROFILE = "Vibrate Mode";
    private final String SILENT_MODE_PROFILE = "Silent Mode";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        notificationManager = (NotificationManager) context.getSystemService(NOTIFICATION_SERVICE);

        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "method.channel.audio");
        channel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "method.channel.audio");
        channel.setMethodCallHandler(new SoundModePlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getRingerMode":
                getCurrentRingerMode(result, audioManager);
                break;
            case "setSilentMode":
                setPhoneToSilentMode(result, audioManager);
                break;
            case "setVibrateMode":
                setPhoneToVibrateMode(result, audioManager);
                break;
            case "setNormalMode":
                setPhoneToNormalMode(result, audioManager);
                break;
            case "openToDoNotDisturbSettings":
                openDoNoAccessSettings();
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void getCurrentRingerMode(MethodChannel.Result result, AudioManager am) {
        int ringerMode = am.getRingerMode();

        switch (ringerMode) {
            case AudioManager.RINGER_MODE_NORMAL:
                result.success(NORMAL_MODE_PROFILE);
                break;
            case AudioManager.RINGER_MODE_SILENT:
                result.success(SILENT_MODE_PROFILE);
                break;
            case AudioManager.RINGER_MODE_VIBRATE:
                result.success(VIBRATE_MODE_PROFILE);
                break;
            default:
                result.error("UNAVAILABLE",
                        "Unable to get ringer mode for the current device",
                        null
                );
        }
    }

    private boolean apiIsAboveMarshmallow() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M;
    }

    private boolean permissionsAreNotEnabled() {
        return apiIsAboveMarshmallow() && !notificationManager.isNotificationPolicyAccessGranted();
    }

    private void setPhoneToSilentMode(MethodChannel.Result result, AudioManager audioManager) {
        if (permissionsAreNotEnabled()) {
            result.error("NOT ALLOWED", "Do not disturb permissions not enabled for current device!", null);
        } else {
            audioManager.setRingerMode(AudioManager.RINGER_MODE_SILENT);
            result.success(SILENT_MODE_PROFILE);
        }
    }

    private void setPhoneToVibrateMode(MethodChannel.Result result, AudioManager audioManager) {
        if (permissionsAreNotEnabled()) {
            result.error("NOT ALLOWED", "Do not disturb permissions not enabled for current device!", null);
        } else {
            audioManager.setRingerMode(AudioManager.RINGER_MODE_VIBRATE);
            result.success(VIBRATE_MODE_PROFILE);
        }
    }

    private void setPhoneToNormalMode(MethodChannel.Result result, AudioManager audioManager) {
        if (permissionsAreNotEnabled()) {
            result.error("NOT ALLOWED", "Do not disturb permissions not enabled for current device!", null);
        } else {
            audioManager.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
            result.success(NORMAL_MODE_PROFILE);
        }
    }

    private void openDoNoAccessSettings() {
        Intent intent = new Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }
}
