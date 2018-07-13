//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by jack sanderson on 26/06/2018.
//  Copyright © 2018 jack sanderson. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var startRecordingButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUi(recording: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    @IBAction func recordAudio(_ sender: AnyObject) {
        
        configUi(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
 

    }

    @IBAction func stopRecording(_ sender: Any) {
        configUi(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Recording was not successful")
        }
    }
    
    func configUi(recording: Bool){
        if(recording){
            recordingLabel.text = "Recording In Progress"
            stopRecordingButton.isEnabled = recording
            startRecordingButton.isEnabled = !recording
        }else{
            stopRecordingButton.isEnabled = recording
            startRecordingButton.isEnabled = !recording
            recordingLabel.text = "Tap to record"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "stopRecording" {
            let playSoundsVC = segue.destination as! playSoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}
