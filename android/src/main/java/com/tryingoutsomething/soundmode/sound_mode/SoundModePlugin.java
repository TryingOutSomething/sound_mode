package com.tryingoutsomething.soundmode.sound_mode;

import android.app.NotificationManager;
import android.content.Context;
import android.media.AudioManager;

import androidx.annotation.NonNull;

import com.tryingoutsomething.soundmode.sound_mode.services.impl.AudioManagerServiceImpl;
import com.tryingoutsomething.soundmode.sound_mode.services.impl.IntentManagerServiceImpl;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Main plugin class for handling method calls.
 */
public class SoundModePlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {
    private MethodChannel channel;
    private AudioManagerServiceImpl audioManagerService;
    private IntentManagerServiceImpl intentManagerService;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        audioManagerService = new AudioManagerServiceImpl(audioManager, notificationManager);
        intentManagerService = new IntentManagerServiceImpl(notificationManager);

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "method.channel.audio");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getRingerMode":
                result.success(audioManagerService.getCurrentRingerMode());
                break;
            case "setSilentMode":
                result.success(audioManagerService.setRingerMode(AudioManager.RINGER_MODE_SILENT));
                break;
            case "setVibrateMode":
                result.success(audioManagerService.setRingerMode(AudioManager.RINGER_MODE_VIBRATE));
                break;
            case "setNormalMode":
                result.success(audioManagerService.setRingerMode(AudioManager.RINGER_MODE_NORMAL));
                break;
            case "openSettings":
                intentManagerService.launchSettings(context);
                result.success(null);
                break;
            case "checkPermissions":
                result.success(intentManagerService.permissionsGranted());
                break;
            default:
                result.notImplemented();
        }
    }
}
