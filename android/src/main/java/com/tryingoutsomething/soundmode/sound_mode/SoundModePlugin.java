package com.tryingoutsomething.soundmode.sound_mode;

import android.content.Context;
import android.media.AudioManager;

import androidx.annotation.NonNull;

import com.tryingoutsomething.soundmode.sound_mode.Utils.ErrorUtil;
import com.tryingoutsomething.soundmode.sound_mode.services.impl.AudioManagerServiceImpl;
import com.tryingoutsomething.soundmode.sound_mode.services.impl.IntentManagerServiceImpl;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * SoundModePlugin
 */
public class SoundModePlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private AudioManagerServiceImpl audioManagerService;
    private IntentManagerServiceImpl intentManagerService;

    //    private static AudioManager audioManager;
//    private static NotificationManager notificationManager;
//    private Context context;

    public SoundModePlugin() {
        audioManagerService = new AudioManagerServiceImpl(null);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Context context = flutterPluginBinding.getApplicationContext();

        audioManagerService = new AudioManagerServiceImpl(context);
        intentManagerService = new IntentManagerServiceImpl(context);

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
                getCurrentRingerMode(result);
                break;
            case "setSilentMode":
                setPhoneToSilentMode(result);
                break;
            case "setVibrateMode":
                setPhoneToVibrateMode(result);
                break;
            case "setNormalMode":
                setPhoneToNormalMode(result);
                break;
            case "openToDoNotDisturbSettings":
                intentManagerService.launchSettings();
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void getCurrentRingerMode(MethodChannel.Result result) {
        String ringerMode = audioManagerService.getCurrentRingerMode();

        if (ringerMode == null) {
            result.error(ErrorUtil.SERVICE_UNAVAILABLE.errorCode,
                    ErrorUtil.SERVICE_UNAVAILABLE.errorMessage,
                    ErrorUtil.SERVICE_UNAVAILABLE.errorDetails
            );
        } else {
            result.success(ringerMode);
        }
    }

//    private boolean apiIsAboveMarshmallow() {
//        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M;
//    }
//
//    private boolean permissionsAreNotEnabled() {
//        return apiIsAboveMarshmallow() && !notificationManager.isNotificationPolicyAccessGranted();
//    }

    private void setPhoneToSilentMode(MethodChannel.Result result) {
        if (intentManagerService.permissionsNotGranted()) {
            result.error(ErrorUtil.INVALID_PERMISSIONS.errorCode,
                    ErrorUtil.INVALID_PERMISSIONS.errorMessage,
                    ErrorUtil.INVALID_PERMISSIONS.errorDetails
            );
        } else {
            String currentMode = audioManagerService.setRingerMode(AudioManager.RINGER_MODE_SILENT);
            result.success(currentMode);
        }
    }

    private void setPhoneToVibrateMode(MethodChannel.Result result) {
        if (intentManagerService.permissionsNotGranted()) {
            result.error(ErrorUtil.INVALID_PERMISSIONS.errorCode,
                    ErrorUtil.INVALID_PERMISSIONS.errorMessage,
                    ErrorUtil.INVALID_PERMISSIONS.errorDetails
            );
        } else {
            String currentMode = audioManagerService.setRingerMode(AudioManager.RINGER_MODE_VIBRATE);
            result.success(currentMode);
        }
    }

    private void setPhoneToNormalMode(MethodChannel.Result result) {
        if (intentManagerService.permissionsNotGranted()) {
            result.error(ErrorUtil.INVALID_PERMISSIONS.errorCode,
                    ErrorUtil.INVALID_PERMISSIONS.errorMessage,
                    ErrorUtil.INVALID_PERMISSIONS.errorDetails
            );
        } else {
            String currentMode = audioManagerService.setRingerMode(AudioManager.RINGER_MODE_SILENT);
            result.success(currentMode);
        }
    }

//    private void openDoNoAccessSettings() {
//        Intent intent = new Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS);
//        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        context.startActivity(intent);
//    }
}
