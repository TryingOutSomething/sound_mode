#import "SoundModePlugin.h"
#if __has_include(<sound_mode/sound_mode-Swift.h>)
#import <sound_mode/sound_mode-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sound_mode-Swift.h"
#endif

@implementation SoundModePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSoundModePlugin registerWithRegistrar:registrar];
}
@end
