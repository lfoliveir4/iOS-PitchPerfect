//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Luis Filipe Alves de Oliveira on 19/03/2022.
//  Copyright © 2022 Luis Filipe Alves de Oliveira. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {


    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlayButtonsEnabled(true)
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        setPlayButtonsEnabled(false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        )[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(
            .playAndRecord,
            mode: .spokenAudio,
            options: .defaultToSpeaker
        )
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        setPlayButtonsEnabled(true)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        flag ? performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) : print("recording was nor succesful")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundViewController = segue.destination as! PlaySoundsViewController
            let recordedSoundURL = sender as! URL
            playSoundViewController.recordedAudioURL = recordedSoundURL
        }
    }
    
    func setPlayButtonsEnabled(_ enabled: Bool) {
        stopRecordingButton.isEnabled = !enabled
        recordButton.isEnabled = enabled
        recordingLabel.text = enabled ? "Tap to Record" : "Recording in progress"
    }
}
