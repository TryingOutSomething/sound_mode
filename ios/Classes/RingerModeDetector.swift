import Foundation
import AudioToolbox

public class RingerModeDetector: NSObject {

    public static let instance = RingerModeDetector()

    var soundId : SystemSoundID = 0

    private static var soundUrl: URL {
        guard let soundUrl = Bundle(for: RingerModeDetector.self).url(forResource: "silence", withExtension: "aiff") else {
            fatalError("File silence.aiff not found")
        }
        return soundUrl
    }
        
    private var startTime : CFTimeInterval? = nil
    
    public typealias RingerModeDetectorCompletion = ((Bool) -> ())

    private var listOfCompletions: [RingerModeDetectorCompletion] = []
    
    public func detect(_ e: @escaping RingerModeDetectorCompletion) {
        guard soundId != 0 else {
            e(false)
            return
        }
        
        self.listOfCompletions.append(e)
        
        if self.startTime == nil {
            self.startTime = CACurrentMediaTime()
            AudioServicesPlaySystemSound(self.soundId)
        }
    }
    
    private override init() {
        super.init()
        self.soundId = 1
        
        let result = AudioServicesCreateSystemSoundID(RingerModeDetector.soundUrl as CFURL, &soundId)
        
        if result == kAudioServicesNoError {
            setupAudioServicesCompletion()
        } else {
            self.soundId = 0
        }
    }
    
    public func setupAudioServicesCompletion() -> Void {
        let rowPointer = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())
        
        AudioServicesAddSystemSoundCompletion(self.soundId, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue, { soundId, rowPointer in
            guard let pointer = rowPointer else {
                fatalError("Pointer is empty")
            }
            let value = Unmanaged<RingerModeDetector>.fromOpaque(pointer).takeUnretainedValue()
            guard let startTime = value.startTime else {
                fatalError("Start time is empty")
            }

            let isMute = CACurrentMediaTime() - startTime < 0.1

            value.listOfCompletions.forEach({(e) in e(isMute)})
            value.listOfCompletions.removeAll()
            value.startTime = nil
        }, rowPointer)
        
        var yes : UInt32 = 1
        AudioServicesSetProperty(kAudioServicesPropertyIsUISound, UInt32(MemoryLayout.size(ofValue: self.soundId)), &self.soundId, UInt32(MemoryLayout.size(ofValue: yes)), &yes)
    }
    
    deinit {
        if self.soundId != 0 {
            AudioServicesRemoveSystemSoundCompletion(self.soundId)
            AudioServicesDisposeSystemSoundID(self.soundId)
        }
    }
}
