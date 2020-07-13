package com.tryingoutsomething.soundmode.sound_mode.Utils;

public class ErrorUtil {

    public static final class INVALID_PERMISSIONS {
        public static final String errorCode = "NOT ALLOWED";
        public static final String errorMessage = "Do not disturb permissions not enabled for current device!";
        public static final String errorDetails = null;
    }

    public static final class SERVICE_UNAVAILABLE {
        public static final String errorCode = "UNAVAILABLE";
        public static final String errorMessage = "Unable to get ringer mode for the current device";
        public static final String errorDetails = null;
    }
}
