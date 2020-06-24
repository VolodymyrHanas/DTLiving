//
//  CameraViewController.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/1/31.
//  Copyright © 2020 Dan Jiang. All rights reserved.
//

import UIKit
import SnapKit

class CameraViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }

    private var liveManager: LiveManager!

    private let recordButton = UIButton()
    private let liveButton = UIButton()
    private let settingsButton = UIButton()
    
    private var isRecording = false

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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        liveManager = LiveManager(position: .back)
        liveManager.delegate = self        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.black
        }

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
        liveButton.setTitleColor(UIColor.white, for: .normal)
        settingsButton.setTitleColor(UIColor.white, for: .normal)
        recordButton.setTitle("start recording", for: .normal)
        liveButton.setTitle("start living", for: .normal)
        settingsButton.setTitle("more menus", for: .normal)

        view.addSubview(recordButton)
        view.addSubview(liveButton)
        view.addSubview(settingsButton)

        recordButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalTo(settingsButton)
        }
        liveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(settingsButton)
        }
        settingsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-10)
            }
        }
        
        recordButton.addTarget(self, action: #selector(record), for: .touchUpInside)
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
    
    @objc private func record() {
        recordButton.isEnabled = false
        if isRecording {
            liveManager.stopRecording()
        } else {
            liveManager.startRecording()
        }
    }
        
    @objc private func showSettings() {
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera Position", style: .default, handler: { [weak self] _ in
            self?.configCameraPosition()
        }))
        alert.addAction(UIAlertAction(title: "Config Filters", style: .default, handler: { [weak self] _ in
            self?.configFilters()
        }))
        alert.addAction(UIAlertAction(title: "Play Music", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Share Video", style: .default, handler: { [weak self] _ in
            self?.shareVideo()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func configCameraPosition() {
        let alert = UIAlertController(title: "Camera Position", message: nil, preferredStyle: .actionSheet)
        for position in VideoCamera.Position.all {
            var title = position.title
            if position == liveManager.position {
                title = "[ \(title) ]"
            }
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.liveManager.position = position
                self.liveManager.rotateCamera()
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func configFilters() {
        let filtersVC = FiltersViewController(liveManager: liveManager)
        let navVC = UINavigationController(rootViewController: filtersVC)
        present(navVC, animated: true, completion: nil)
    }
    
    private func shareVideo() {
        if let videoFile = FileHelper.shared.getMediaFileURL(name: "video", ext: "mp4", needRemove: false) {
            let activityVC = UIActivityViewController(activityItems: [videoFile], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
        
}

extension CameraViewController: LiveManagerDelegate {
    
    func liveManagerRecorderDidFinishPreparing(_ manager: LiveManager) {
        isRecording = true
        recordButton.setTitle("stop recording", for: .normal)
        recordButton.isEnabled = true
    }
    
    func liveManagerRecorder(_ manager: LiveManager, didFailWithError error: Error?) {
        isRecording = false
        recordButton.setTitle("start recording", for: .normal)
        recordButton.isEnabled = true
    }
    
    func liveManagerRecorderDidFinishRecording(_ manager: LiveManager) {
        isRecording = false
        recordButton.setTitle("start recording", for: .normal)
        recordButton.isEnabled = true
    }
    
}
