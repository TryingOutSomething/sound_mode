#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sound_mode.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sound_mode'
  s.version          = '0.0.1'
  s.summary          = 'A plugin to manage devices sound mode'
  s.description      = <<-DESC
A plugin to manage device sound mode
                       DESC
  s.homepage         = 'https://github.com/TryingOutSomething/sound_mode'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.resources = 'Assets/*.aiff'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
  s.frameworks = 'Foundation', 'AudioToolbox'
end
