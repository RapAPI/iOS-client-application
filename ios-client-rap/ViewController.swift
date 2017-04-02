//
//  ViewController.swift
//  ios-client-rap
//
//  Created by Remi Robert on 01/04/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation
import SceneKit
import AudioIndicatorBars
import SnapKit
import ChainableAnimations
import VSSpritz

class ViewController: UIViewController {

    fileprivate var audioPlayer: AVPlayer!
    fileprivate var audioPlayer2: AVPlayer!
    fileprivate var trigger = Int(60 * (1 / 60))
    fileprivate var counter = 0
    fileprivate var count = 0
    fileprivate var ready = false
    @IBOutlet weak var chartView: AudioIndicatorBarsView!
    @IBOutlet weak var playbutton: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var readView: VSSpritzLabel!
    var readController: VSSpritzViewController!
    @IBOutlet weak var voicePikcer: UIPickerView!
    @IBOutlet weak var pickercontainerview: UIView!
    var currentBeat: String = "beat1"
    @IBOutlet weak var cancelButton: UIButton!

    var beats = [
        "beat1",
        "beat2",
        "beat3"
    ]

    var voicies = [
        "geraint",
        "gwyneth",
        "mads",
        "naja",
        "hans",
        "marlene",
        "nicole",
        "russell",
        "amy",
        "brian",
        "emma",
        "raveena",
        "ivy",
        "joanna",
        "joey",
        "justin"
    ]

    @IBAction func cancel(_ sender: Any) {
        self.audioPlayer.pause()
        self.audioPlayer2.pause()
        self.showControls()
    }

    @IBAction func selectBeats(_ sender: Any) {
        voicePikcer.tag = 2
        voicePikcer.reloadAllComponents()
        self.pickercontainerview.isHidden = false
    }

    @IBAction func finishSelectionVoice(_ sender: Any) {
        self.pickercontainerview.isHidden = true
    }

    @IBAction func selectVoice(_ sender: Any) {
        voicePikcer.tag = 1
        voicePikcer.reloadAllComponents()
        self.pickercontainerview.isHidden = false
    }

    private func startSound() {

        let string = "I want some food. Don't be rude. It is about to conclude. If you need time. I got a rhyme. Something about bouncing. He is just announcing. Put it in the table. Bring me the cable"

        AWSPollyManager.shared.buildSong(text: string) { [weak self] url in
            guard let url = url else {return}

            //            let data = try! Data(contentsOf: url as URL)
            //            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("test.jpg")
            //
            //            do {
            //                try data.write(to: fileURL, options: .atomic)
            //            } catch {return}

            let path = Bundle.main.url(forResource: self?.currentBeat, withExtension: "mp3")
            print("url : \(path)")
            self?.audioPlayer2 = AVPlayer(url: path!)
            self?.audioPlayer2.play()

            self?.readController = VSSpritzViewController(bodyText: string)
            self?.readController.wordsPerMinute = 300
            self?.readController.spritzView = self?.readView
            self?.readController.start()

            self?.audioPlayer = AVPlayer(url: url as URL)
            self?.audioPlayer2.volume = 0.5
            self?.audioPlayer.play()

            DispatchQueue.main.async {
                self?.chartView.start()
            }
        }
    }

    private func showControls() {
        self.chartView.stop()
        cancelButton.isHidden = true
        let animator = ChainableAnimator(view: self.loader)
        let animator2 = ChainableAnimator(view: self.playbutton)
        animator.moveY(y: Float(170)).spring.animate(t: 0.5)
        animator2.moveY(y: Float(-180)).delay(t: 0.5).spring.animate(t: 0.3)
    }

    private func hideControls() {
        let animator = ChainableAnimator(view: self.playbutton)
        let animator2 = ChainableAnimator(view: self.loader)
        cancelButton.isHidden = false
        loader.isHidden = false
        animator.moveY(y: Float(180)).spring.animate(t: 0.5)
        animator2.moveY(y: Float(-170)).delay(t: 0.5).spring.animate(t: 0.3)
    }

    @IBAction func playSound(_ sender: Any) {
        hideControls()
        self.startSound()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let animator = ChainableAnimator(view: self.loader)
        animator.moveY(y: Float(170)).spring.animate(t: 0.1)
        cancelButton.isHidden = true
        playbutton.layer.cornerRadius = 30
        view.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loader.startAnimating()

        voicePikcer.dataSource = self
        voicePikcer.delegate = self

        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { _ in
            self.audioPlayer2.pause()
            DispatchQueue.main.async {
                self.showControls()
            }
        }
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            let voiceId = AWSVoice(rawValue: self.voicies[row])!.voice()
            AWSPollyManager.shared.input.voiceId = voiceId
        } else {
            self.currentBeat = self.beats[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 1 ? self.voicies[row] : self.beats[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 1 ? self.voicies.count : self.beats.count
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        print("get interuption")
    }
}
