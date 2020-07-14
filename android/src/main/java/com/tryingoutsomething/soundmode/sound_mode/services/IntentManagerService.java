package com.tryingoutsomething.soundmode.sound_mode.services;

import android.content.Context;

public interface IntentManagerService {

    boolean permissionsGranted();
    void launchSettings(Context context);
}
