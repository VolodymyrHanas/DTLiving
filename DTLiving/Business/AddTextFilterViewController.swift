//
//  AddTextFilterViewController.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/29.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit

protocol AddTextFilterViewControllerDelegate: class {
    func addTextFilter(_ filter: VideoTextFilter)
}

class AddTextFilterViewController: UIViewController {

    weak var delegate: AddTextFilterViewControllerDelegate?

    private let filter: VideoTextFilter

    private let textField = UITextField()
    private let fontSizeTextField = UITextField()
    private let fontColorSegmentedControl = UISegmentedControl(items: ["Red", "Green", "Blue", "White", "Black"])
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(filter: VideoTextFilter) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        
        let label1 = UILabel()
        label1.text = "Text"
        view.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
        }
        
        textField.text = "Hello"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        let label2 = UILabel()
        label2.text = "Font Size"
        view.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
        }
        
        fontSizeTextField.text = "12"
        fontSizeTextField.keyboardType = .numberPad
        fontSizeTextField.layer.borderColor = UIColor.black.cgColor
        fontSizeTextField.layer.borderWidth = 1
        view.addSubview(fontSizeTextField)
        fontSizeTextField.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        let label3 = UILabel()
        label3.text = "Font Color"
        view.addSubview(label3)
        label3.snp.makeConstraints { make in
            make.top.equalTo(fontSizeTextField.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
        }

        fontColorSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(fontColorSegmentedControl)
        fontColorSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(label3.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
    }

    @objc private func save() {
        let text = textField.text ?? ""
        let fontSize = Float(fontSizeTextField.text ?? "0") ?? 0
        var fontColor = UIColor.white
        switch fontColorSegmentedControl.selectedSegmentIndex {
        case 0:
            fontColor = .red
        case 1:
            fontColor = .green
        case 2:
            fontColor = .blue
        case 3:
            fontColor = .white
        case 4:
            fontColor = .black
        default:
            break
        }
        let attributedText = NSAttributedString(string: text,
                                                attributes: [.font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)),
                                                             .foregroundColor: fontColor])
        filter.setText(attributedText, size: .init(width: 720, height: 1280))
        delegate?.addTextFilter(filter)
    }

}
