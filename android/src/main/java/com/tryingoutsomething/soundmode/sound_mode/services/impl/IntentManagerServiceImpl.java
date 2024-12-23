package com.tryingoutsomething.soundmode.sound_mode.services.impl;

import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;

import com.tryingoutsomething.soundmode.sound_mode.services.IntentManagerService;

public class IntentManagerServiceImpl implements IntentManagerService {

    private final NotificationManager notificationManager;

    public IntentManagerServiceImpl(NotificationManager notificationManager) {
        this.notificationManager = notificationManager;
    }

    @Override
    public boolean permissionsGranted() {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || notificationManager.isNotificationPolicyAccessGranted();
    }

    @Override
    public void launchSettings(Context context) {
        Intent intent = new Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }
}
