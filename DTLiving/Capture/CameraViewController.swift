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

    private var pipeline: CameraPipeline

    private let recordButton = UIButton()
    private let liveButton = UIButton()
    private let settingsButton = UIButton()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(config: MediaConfig) {
        pipeline = CameraPipeline(config: config)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupButtons()
    }
    
    private func setupButtons() {
        recordButton.setTitleColor(UIColor.white, for: .normal)
        recordButton.setTitle("start recording", for: .normal)
        liveButton.setTitleColor(UIColor.white, for: .normal)
        liveButton.setTitle("start living", for: .normal)
        settingsButton.setTitleColor(UIColor.white, for: .normal)
        settingsButton.setTitle("config settings", for: .normal)
        
        view.addSubview(recordButton)
        view.addSubview(liveButton)
        view.addSubview(settingsButton)

        recordButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-10)
            }
        }
        liveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-10)
            }
        }
        settingsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-10)
            }
        }
        
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
    }
    
    @objc private func showSettings() {
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera Position", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Video Ratio", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Watermark", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Face Beauty", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Play Music", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

