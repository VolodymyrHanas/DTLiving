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

    private let recordButton = UIButton()
    private let liveButton = UIButton()
    private let settingsButton = UIButton()

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
        alert.addAction(UIAlertAction(title: "Video Bit Rate", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Video Ratio", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Video Frame Rate", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Camera Position", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Watermark", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Face Beauty", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Play Music", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

