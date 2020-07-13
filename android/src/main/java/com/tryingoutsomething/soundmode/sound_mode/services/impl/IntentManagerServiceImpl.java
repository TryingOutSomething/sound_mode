package com.tryingoutsomething.soundmode.sound_mode.services.impl;

import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;

import com.tryingoutsomething.soundmode.sound_mode.services.IntentManagerService;

public class IntentManagerServiceImpl implements IntentManagerService {

    NotificationManager notificationManager;

    public IntentManagerServiceImpl(NotificationManager nm) {
        this.notificationManager = nm;
    }

    private boolean apiIsAboveMarshmallow() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M;
    }

    @Override
    public boolean permissionsNotGranted() {
        return apiIsAboveMarshmallow() && !notificationManager.isNotificationPolicyAccessGranted();
    }

    @Override
    public void launchSettings(Context context) {
        Intent intent = new Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        context.startActivity(intent);
    }
}
