package com.tryingoutsomething.soundmode.sound_mode.services;

import android.content.Context;

public interface IntentManagerService {

    boolean permissionsNotGranted();
    void launchSettings(Context context);
}
