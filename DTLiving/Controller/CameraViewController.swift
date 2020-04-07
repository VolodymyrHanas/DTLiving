//
//  CameraViewController.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/1/31.
//  Copyright © 2020 Dan Jiang. All rights reserved.
//

import UIKit
import SnapKit

enum CameraPosition {
    case front
    case back
    
    var title: String {
        switch self {
        case .front:
            return "Front"
        case .back:
            return "Back"
        }
    }
    
    static var all: [CameraPosition] {
        return [.front, .back]
    }
}

enum VideoRatio {
    case r9to16
    case r16to9
    case r2p39to1
    case r1to1
    case circle
    case r4to3
    case r3to4

    var title: String {
        switch self {
        case .r9to16:
            return "9:16"
        case .r16to9:
            return "16:9"
        case .r2p39to1:
            return "2.39:1"
        case .r1to1:
            return "1:1"
        case .circle:
            return "Circle"
        case .r4to3:
            return "4:3"
        case .r3to4:
            return "3:4"
        }
    }
    
    var ratio: Float { // height : width
        switch self {
        case .r9to16:
            return 16.0 / 9.0
        case .r16to9:
            return 9.0 / 16.0
        case .r2p39to1:
            return 1.0 / 2.39
        case .r1to1:
            return 1.0
        case .circle:
            return 1.0
        case .r4to3:
            return 3.0 / 4.0
        case .r3to4:
            return 4.0 / 3.0
        }
    }
    
    static var all: [VideoRatio] {
        return [.r9to16, .r16to9, .r2p39to1, .r1to1, .circle, .r4to3, .r3to4]
    }
}

struct MediaConfig {
    var cameraPosition: CameraPosition
    let formatName: String = "flv"
    let videoCodecName: String = "h264"
    let videoBitRate: Int = 1500000
    var videoRatio: VideoRatio
    let videoFrameRate: Int = 24
    let audioCodecName: String = "libfdk_aac"
    let audioSampleRate: Int = 44100
    let audioBitRate: Int = 64000
    let audioChannels: Int = 2
    var isWatermark: Bool
    var isFaceBeauty: Bool
    var musicFileURL: String?

    init(cameraPosition: CameraPosition = .back,
         videoRatio: VideoRatio = .r9to16,
         isWatermark: Bool = true,
         isFaceBeauty: Bool = true,
         musicFileURL: String? = nil) {
        self.cameraPosition = cameraPosition
        self.videoRatio = videoRatio
        self.isWatermark = isWatermark
        self.isFaceBeauty = isFaceBeauty
        self.musicFileURL = musicFileURL
    }
}

class CameraViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }

    private let liveManager: LiveManager

    private let recordButton = UIButton()
    private let liveButton = UIButton()
    private let settingsButton = UIButton()
    private let slider = UISlider()

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(config: MediaConfig) {
        liveManager = LiveManager(config: config)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupPreview()
        setupControls()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterBackground(_:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        liveManager.startCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        liveManager.resumeCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        liveManager.pauseCapture()
    }
    
    private func setupPreview() {
        let previewView = liveManager.previewView
        view.addSubview(previewView)
        previewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupControls() {
        recordButton.setTitleColor(UIColor.white, for: .normal)
        recordButton.setTitle("start recording", for: .normal)
        liveButton.setTitleColor(UIColor.white, for: .normal)
        liveButton.setTitle("start living", for: .normal)
        settingsButton.setTitleColor(UIColor.white, for: .normal)
        settingsButton.setTitle("config settings", for: .normal)
        slider.minimumValue = 0
        slider.maximumValue = 3.0
        
        view.addSubview(recordButton)
        view.addSubview(liveButton)
        view.addSubview(settingsButton)
        view.addSubview(slider)

        slider.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-10)
            }
        }
        recordButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalTo(slider.snp.top).offset(-10)
        }
        liveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(slider.snp.top).offset(-10)
        }
        settingsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(slider.snp.top).offset(-10)
        }
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
    }
            
    @objc private func enterForeground(_ notificaton: Notification) {
        if isViewLoaded && view.window != nil {
            liveManager.resumeCapture()
        }
    }
    
    @objc private func enterBackground(_ notificaton: Notification) {
        if isViewLoaded && view.window != nil {
            liveManager.pauseCapture()
        }
    }
    
    @objc private func sliderValueChanged(_ slider: UISlider) {
        let filter = VideoGammaFilter()
        filter.gamma = slider.value
        liveManager.updateFilter(filter)
    }
    
    @objc private func showSettings() {
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera Position", style: .default, handler: { [weak self] _ in
            self?.configCameraPosition()
        }))
        alert.addAction(UIAlertAction(title: "Video Ratio", style: .default, handler: { [weak self] _ in
            self?.configVideoRatio()
        }))
        alert.addAction(UIAlertAction(title: "Watermark", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Face Beauty", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Play Music", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func configCameraPosition() {
        let alert = UIAlertController(title: "Camera Position", message: nil, preferredStyle: .actionSheet)
        for position in CameraPosition.all {
            var title = position.title
            if position == liveManager.config.cameraPosition {
                title = "[ \(title) ]"
            }
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.liveManager.config.cameraPosition = position
                self.liveManager.rotateCamera()
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func configVideoRatio() {
        let alert = UIAlertController(title: "Video Ratio", message: nil, preferredStyle: .actionSheet)
        for videoRatio in VideoRatio.all {
            var title = videoRatio.title
            if videoRatio == liveManager.config.videoRatio {
                title = "[ \(title) ]"
            }
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.liveManager.config.videoRatio = videoRatio
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
