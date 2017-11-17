//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Apple on 16/11/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController : UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var lblRecord: UILabel!
    @IBOutlet weak var btnRecord: UIButton!
    
    @IBOutlet weak var btnStopRecord: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnStopRecord.isEnabled = false
    }

  

    @IBAction func record(_ sender: Any) {
        btnRecord.isEnabled = false
        lblRecord.text = "Recording"
        btnStopRecord.isEnabled = true
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(_ sender: Any) {
        btnStopRecord.isEnabled = false
        lblRecord.text = "Tap to record"
        btnRecord.isEnabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording was not succesful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"
        {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    
}

