//
//  AddMosaicFilterViewController.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/29.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit

protocol AddMosaicFilterViewControllerDelegate: class {
    func addMosaicFilter(_ filter: VideoMosaicFilter)
}

class AddMosaicFilterViewController: UIViewController {

    weak var delegate: AddMosaicFilterViewControllerDelegate?

    private let filter: VideoMosaicFilter

    private let colorSwitch = UISwitch()
    private let imageSegmentedControl = UISegmentedControl(items: ["squares", "dotletterstiles"])

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(filter: VideoMosaicFilter) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mosaic"

        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        
        let label1 = UILabel()
        label1.text = "Color"
        view.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
        }
        
        colorSwitch.isOn = filter.colorOn
        view.addSubview(colorSwitch)
        colorSwitch.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
        }
        
        let label2 = UILabel()
        label2.text = "Image"
        view.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.top.equalTo(colorSwitch.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
        }

        imageSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(imageSegmentedControl)
        imageSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
    }

    @objc private func save() {
        filter.colorOn = colorSwitch.isOn
        filter.imageName = imageSegmentedControl.selectedSegmentIndex == 0 ? "squares" : "dotletterstiles"
        delegate?.addMosaicFilter(filter)
    }

}
