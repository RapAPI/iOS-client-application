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
import Alamofire
import CoreBluetooth

extension Alamofire.SessionManager{
    @discardableResult
    open func requestWithoutCashe(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}

enum MuseState {
    case up
    case down
    case empty
}

class ViewController: UIViewController {

    var museManager = IXNMuseManager.shared()
    fileprivate var audioPlayer: AVPlayer!
    fileprivate var audioPlayer2: AVPlayer!
    fileprivate var audioPlayer3: AVAudioPlayer!
    fileprivate var trigger = Int(60 * (1 / 60))
    fileprivate var counter = 0
    fileprivate var count = 0
    fileprivate var ready = false
    @IBOutlet weak var chartView: AudioIndicatorBarsView!
    @IBOutlet weak var playbutton: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var voicePikcer: UIPickerView!
    @IBOutlet weak var pickercontainerview: UIView!
    var currentBeat: String = "beat1"
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var labelLoading: UILabel!
    @IBOutlet weak var switchHead: UISwitch!
    private var headEnable = false

    var centralManager: CBCentralManager!
    var muse: IXNMuse!
    var museState: MuseState = .empty {
        didSet {
            if self.headEnable {
                let path = Bundle.main.url(forResource: "beat", withExtension: "wav")
                self.audioPlayer3 = try! AVAudioPlayer(contentsOf: path!)
                self.audioPlayer3.volume = 1
                self.audioPlayer3.play()
            }
        }
    }

    @IBAction func enableHead(_ sender: Any) {
        self.headEnable = (sender as! UISwitch).isOn
    }

    @IBOutlet weak var labelContent: UILabel!

    var loading = [
        "go ahead -- hold your breath",
        "why don't you order a sandwich?",
        "the bits are flowing slowly today",
        "making sure that the AI is not sentient"
    ]

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


    private func playSound(string: String) {
        self.labelLoading.isHidden = true

        AWSPollyManager.shared.buildSong(text: string) { [weak self] url in
            guard let url = url else {return}
            let path = Bundle.main.url(forResource: self?.currentBeat, withExtension: "mp3")
            self?.audioPlayer2 = AVPlayer(url: path!)
            self?.audioPlayer2.play()

//            self?.readController.spritzView = self?.readView
            self?.labelContent.text = string

            self?.audioPlayer = AVPlayer(url: url as URL)
            self?.audioPlayer.volume = 0.8
            self?.audioPlayer2.volume = 0.3
            self?.audioPlayer.play()

            DispatchQueue.main.async {
                self?.chartView.start()
            }
        }
    }

    private func startSound() {
        self.labelLoading.isHidden = false

        Alamofire.SessionManager.default.requestWithoutCashe("http://ec2-52-212-142-117.eu-west-1.compute.amazonaws.com/lyrics").responseJSON { response in
            if let JSON = response.result.value as? [String:AnyObject] {
                guard let string = JSON["lyrics"] as? String else {return}
                DispatchQueue.main.async {
                    print("strin := \(string)")
                    self.playSound(string: string)
                }
            }
        }

//        let string = "What check my head and she go to; a whole from all the mommation the dave. You know where we get in the new and we bent the stars!"

    }

    private func showControls() {
        self.chartView.stop()
        self.labelContent.text = nil
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

    @objc func changeLoadingText() {
        let current = self.labelLoading.text
        let strings = self.loading.filter { $0 != current }
        self.labelLoading.text = strings[Int(arc4random()) % strings.count]
        self.perform(#selector(self.changeLoadingText), with: nil, afterDelay: 2.5)
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

        self.perform(#selector(self.changeLoadingText), with: nil, afterDelay: 2.5)

        self.labelContent.text = nil
        self.labelLoading.text = nil
        self.labelLoading.isHidden = true
        self.loader.startAnimating()

        voicePikcer.dataSource = self
        voicePikcer.delegate = self

        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { _ in
            if (self.audioPlayer2) != nil {
                self.audioPlayer2.pause()
            }
            DispatchQueue.main.async {
                self.showControls()
            }
        }

        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
}

extension ViewController: CBCentralManagerDelegate, IXNMuseDataListener {
    @objc func resetTimer() {
        self.museState = .empty
    }
    
    func receive(_ packet: IXNMuseArtifactPacket!) {
    }

    func receive(_ packet: IXNMuseDataPacket!) {
        guard let values = packet.values as? [Double] else {return}
        print("double : \(values)")

        if values[0] > 650 {
            if self.museState != .down {
                print("🥝     up")
                self.perform(#selector(self.resetTimer), with: nil, afterDelay: 1)
                self.museState = .down
            }
        } else if values[0] < -200 {
            self.museState = .empty
        }
    }

    @objc func getMuseDevice() {
        self.perform(#selector(self.getMuseDevice), with: nil, afterDelay: 1)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.museManager?.showMusePicker(completion: { error in
                guard let muse = self.museManager?.connectedMuses.first as? IXNMuse else {return}
                self.muse = muse
                self.muse.register(self, type: IXNMuseDataPacketType.accelerometer)
                self.muse.runAsynchronously()
                print("connected : \(muse)")
            })
            self.perform(#selector(self.getMuseDevice), with: nil, afterDelay: 1)
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
