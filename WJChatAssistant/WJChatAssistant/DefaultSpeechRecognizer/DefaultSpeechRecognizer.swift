//
//  DefaultSpeechRecognizer.swift
//  WJChatAssistant
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation
import Speech
import Accelerate

class DefaultSpeechRecognizer: WJSpeechRecognizerProtocol {
    
    private var partialResultArrivalBlock: resultArrivalBlock?
    private var finalResultArrivalBlock: resultArrivalBlock?
    private var errorOccurBlock: ((Error) -> Void)?
    
    func startListen(_ partialResultArrival: @escaping resultArrivalBlock,
                     _ finalResultArrival: @escaping resultArrivalBlock,
                     _ errorOccur: @escaping (Error) -> Void) {
        
        partialResultArrivalBlock = partialResultArrival
        finalResultArrivalBlock = finalResultArrival
        errorOccurBlock = errorOccur
    }
    
    func stopListen() {
        
    }
    
    func cancelListen() {
        
    }
    
    
}

public class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    // MARK: Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet var textView : UITextView!
    
    @IBOutlet var recordButton : UIButton!
    
    private var averagePower: [Float] = []
    private var peakPower: [Float] = []
    private let LEVEL_LOWPASS_TRIG: Float = 0.1
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isEnabled = false
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
//        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
            
            // 获取音量，声道等信息
            buffer.frameLength = 1024
            let inNumberFrames = vDSP_Length(buffer.frameLength)
            
            self.averagePower.append(contentsOf: Array.init(repeating: 0, count: Int(buffer.format.channelCount) - self.averagePower.count))
            for channel in 0..<buffer.format.channelCount {
                let samples = buffer.floatChannelData![Int(channel)]
                var avgValue: Float = 0
                var maxValue: Float = 0
                
                vDSP_meamgv(samples, 1, &avgValue, inNumberFrames)
                vDSP_maxmgv(samples, 1, &maxValue, inNumberFrames)
                self.averagePower[Int(channel)] = (self.LEVEL_LOWPASS_TRIG * ((avgValue==0) ? -100 : 20.0*log10f(avgValue))) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePower[Int(channel)])
                self.peakPower[Int(channel)] = (self.LEVEL_LOWPASS_TRIG * ((maxValue==0) ? -100 : 20.0*log10f(maxValue))) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePower[Int(channel)])
            }
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        textView.text = "(Go ahead, I'm listening)"
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        } else {
            try! startRecording()
            recordButton.setTitle("Stop recording", for: [])
        }
    }
}
