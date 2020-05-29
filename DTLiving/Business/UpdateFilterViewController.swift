//
//  UpdateFilterViewController.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/28.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit

protocol UpdateFilterViewControllerDelegate: class {
    func updateFilter(_ filter: VideoFilter, at index: Int)
}

class UpdateFilterViewController: UITableViewController {
    
    weak var delegate: UpdateFilterViewControllerDelegate?

    private let filter: VideoFilter
    private let index: Int
    
    private var rotationAngle: Float = 0
    private var scaleX: Float = 1.0
    private var scaleY: Float = 1.0
    private var translationX: Float = 0
    private var translationY: Float = 0

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(filter: VideoFilter, index: Int) {
        self.filter = filter
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = filter.name
        
        tableView.isScrollEnabled = false
        tableView.rowHeight = 70
        
        tableView.register(SliderCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if filter is VideoLevelsFilter {
            return 3
        } else if filter is VideoRGBFilter {
            return 3
        } else if filter is VideoTransformFilter
            || filter is VideoWaterMaskFilter
            || filter is VideoTextFilter {
            return 5
        } else if filter is VideoCropFilter {
            return 4
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if filter is VideoBrightnessFilter {
            return "brightness"
        } else if filter is VideoExposureFilter {
            return "exposure"
        } else if filter is VideoContrastFilter {
            return "contrast"
        } else if filter is VideoSaturationFilter {
            return "saturation"
        } else if filter is VideoGammaFilter {
            return "gamma"
        } else if filter is VideoLevelsFilter {
            switch section {
            case 0:
                return "Red Min"
            case 1:
                return "Green Min"
            default:
                return "Blue Min"
            }
        } else if filter is VideoRGBFilter {
            switch section {
            case 0:
                return "Red"
            case 1:
                return "Green"
            default:
                return "Blue"
            }
        } else if filter is VideoHueFilter {
            return "hue"
        } else if filter is VideoTransformFilter
            || filter is VideoWaterMaskFilter
            || filter is VideoTextFilter {
            switch section {
            case 0:
                return "rotationAngle"
            case 1:
                return "scaleX"
            case 2:
                return "scaleY"
            case 3:
                return "translationX"
            default:
                return "translationY"
            }
        } else if filter is VideoCropFilter {
            switch section {
            case 0:
                return "x"
            case 1:
                return "y"
            case 2:
                return "width"
            default:
                return "height"
            }
        } else if filter is VideoGaussianBlurFilter || filter is VideoBoxBlurFilter {
            return "blurRadiusInPixels"
        } else if filter is VideoSobelEdgeDetectionFilter || filter is VideoSketchFilter {
            return "edgeStrength"
        } else if filter is VideoSharpenFilter {
            return "sharpness"
        } else if filter is VideoBilateralFilter {
            return "distanceNormalizationFactor"
        } else if filter is VideoAlphaBlendFilter {
            return "mixturePercent"
        } else if filter is VideoEmbossFilter {
            return "intensity"
        } else if filter is VideoToonFilter {
            return "threshold"
        } else if filter is VideoMosaicFilter {
            return "displayTileSize"
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? SliderCell else {
            return UITableViewCell()
        }
        
        if let filter = filter as? VideoBrightnessFilter {
            cell.setValue(filter.brightness, min: -1.0, max: 1.0)
            cell.didChange = { value in
                filter.brightness = value
            }
        } else if let filter = filter as? VideoExposureFilter {
            cell.setValue(filter.exposure, min: -10.0, max: 10.0)
            cell.didChange = { value in
                filter.exposure = value
            }
        } else if let filter = filter as? VideoContrastFilter {
            cell.setValue(filter.contrast, min: 0.0, max: 4.0)
            cell.didChange = { value in
                filter.contrast = value
            }
        } else if let filter = filter as? VideoSaturationFilter {
            cell.setValue(filter.saturation, min: 0.0, max: 2.0)
            cell.didChange = { value in
                filter.saturation = value
            }
        } else if let filter = filter as? VideoGammaFilter {
            cell.setValue(filter.gamma, min: 0.0, max: 3.0)
            cell.didChange = { value in
                filter.gamma = value
            }
        } else if let filter = filter as? VideoLevelsFilter {
            switch indexPath.section {
            case 0:
                cell.setValue(filter.min.x, min: 0.0, max: 1.0)
                cell.didChange = { value in
                    filter.setRedMin(value, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0)
                }
            case 1:
                cell.setValue(filter.min.y, min: 0.0, max: 1.0)
                cell.didChange = { value in
                    filter.setGreenMin(value, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0)
                }
            default:
                cell.setValue(filter.min.z, min: 0.0, max: 1.0)
                cell.didChange = { value in
                    filter.setBlueMin(value, gamma: 1.0, max: 1.0, minOut: 0.0, maxOut: 1.0)
                }
            }
        } else if let filter = filter as? VideoRGBFilter {
            switch indexPath.section {
            case 0:
                cell.setValue(filter.red, min: 0.0, max: 1.0)
                cell.didChange = { value in
                    filter.red = value
                }
            case 1:
                cell.setValue(filter.green, min: 0.0, max: 1.0)
                cell.didChange = { value in
                    filter.green = value
                }
            default:
                cell.setValue(filter.blue, min: 0.0, max: 1.0)
                cell.didChange = { value in
                    filter.blue = value
                }
            }
        } else if let filter = filter as? VideoHueFilter {
            cell.setValue(filter.hue, min: 0.0, max: 360.0)
            cell.didChange = { value in
                filter.hue = value
            }
        } else if filter is VideoTransformFilter {
            switch indexPath.section {
            case 0:
                cell.setValue(rotationAngle, min: 0.0, max: 2.0 * .pi)
                cell.didChange = { [weak self] value in
                    self?.rotationAngle = value
                }
            case 1:
                cell.setValue(scaleX, min: 0.0, max: 2.0)
                cell.didChange = { [weak self] value in
                    self?.scaleX = value
                }
            case 2:
                cell.setValue(scaleY, min: 0.0, max: 2.0)
                cell.didChange = { [weak self] value in
                    self?.scaleY = value
                }
            case 3:
                cell.setValue(translationX, min: -1.0, max: 1.0)
                cell.didChange = { [weak self] value in
                    self?.translationX = value
                }
            default:
                cell.setValue(translationY, min: -1.0, max: 1.0)
                cell.didChange = { [weak self] value in
                    self?.translationY = value
                }
            }
        } else if let filter = filter as? VideoCropFilter {
            switch indexPath.section {
            case 0:
                cell.setValue(Float(filter.cropRegion.origin.x), min: 0.0, max: 1.0)
                cell.didChange = { value in
                    filter.cropRegion.origin.x = CGFloat(value)
                }
            case 1:
                cell.setValue(Float(filter.cropRegion.origin.y), min: 0.0, max: 1.0)
                cell.didChange = { value in
                    filter.cropRegion.origin.y = CGFloat(value)
                }
            case 2:
                cell.setValue(Float(filter.cropRegion.size.width), min: 0.0, max: 1.0)
                cell.didChange = { value in
                    filter.cropRegion.size.width = CGFloat(value)
                }
            default:
                cell.setValue(Float(filter.cropRegion.size.height), min: 0.0, max: 1.0)
                cell.didChange = { value in
                    filter.cropRegion.size.height = CGFloat(value)
                }
            }
        } else if let filter = filter as? VideoGaussianBlurFilter {
            cell.setValue(filter.blurRadiusInPixels, min: 0.0, max: 24.0)
            cell.didChange = { value in
                filter.blurRadiusInPixels = value
            }
        } else if let filter = filter as? VideoBoxBlurFilter {
            cell.setValue(filter.blurRadiusInPixels, min: 0.0, max: 24.0)
            cell.didChange = { value in
                filter.blurRadiusInPixels = value
            }
        } else if let filter = filter as? VideoSobelEdgeDetectionFilter {
            cell.setValue(filter.edgeStrength, min: 0.0, max: 1.0)
            cell.didChange = { value in
                filter.edgeStrength = value
            }
        } else if let filter = filter as? VideoSharpenFilter {
            cell.setValue(filter.sharpness, min: -1.0, max: 4.0)
            cell.didChange = { value in
                filter.sharpness = value
            }
        } else if let filter = filter as? VideoBilateralFilter {
            cell.setValue(filter.distanceNormalizationFactor, min: 0.0, max: 10.0)
            cell.didChange = { value in
                filter.distanceNormalizationFactor = value
            }
        } else if let filter = filter as? VideoAlphaBlendFilter {
            cell.setValue(filter.mixturePercent, min: 0.0, max: 1.0)
            cell.didChange = { value in
                filter.mixturePercent = value
            }
        } else if let filter = filter as? VideoWaterMaskFilter {
            switch indexPath.section {
            case 0:
                cell.setValue(Float(filter.rotate), min: 0.0, max: 2.0 * .pi)
                cell.didChange = { value in
                    filter.rotate = CGFloat(value)
                }
            case 1:
                cell.setValue(Float(filter.scale.width), min: 0.0, max: 2.0)
                cell.didChange = { value in
                    filter.scale.width = CGFloat(value)
                }
            case 2:
                cell.setValue(Float(filter.scale.height), min: 0.0, max: 2.0)
                cell.didChange = { value in
                    filter.scale.height = CGFloat(value)
                }
            case 3:
                cell.setValue(Float(filter.translate.width), min: -360, max: 360)
                cell.didChange = { value in
                    filter.translate.width = CGFloat(value)
                }
            default:
                cell.setValue(Float(filter.translate.height), min: -640, max: 640)
                cell.didChange = { value in
                    filter.translate.height = CGFloat(value)
                }
            }
        } else if let filter = filter as? VideoTextFilter {
            switch indexPath.section {
            case 0:
                cell.setValue(Float(filter.rotate), min: 0.0, max: 2.0 * .pi)
                cell.didChange = { value in
                    filter.rotate = CGFloat(value)
                }
            case 1:
                cell.setValue(Float(filter.scale.width), min: 0.0, max: 2.0)
                cell.didChange = { value in
                    filter.scale.width = CGFloat(value)
                }
            case 2:
                cell.setValue(Float(filter.scale.height), min: 0.0, max: 2.0)
                cell.didChange = { value in
                    filter.scale.height = CGFloat(value)
                }
            case 3:
                cell.setValue(Float(filter.translate.width), min: -360, max: 360)
                cell.didChange = { value in
                    filter.translate.width = CGFloat(value)
                }
            default:
                cell.setValue(Float(filter.translate.height), min: -640, max: 640)
                cell.didChange = { value in
                    filter.translate.height = CGFloat(value)
                }
            }
        } else if let filter = filter as? VideoEmbossFilter {
            cell.setValue(filter.intensity, min: 0.0, max: 4.0)
            cell.didChange = { value in
                filter.intensity = value
            }
        } else if let filter = filter as? VideoToonFilter {
            cell.setValue(filter.threshold, min: 0.0, max: 1.0)
            cell.didChange = { value in
                filter.threshold = value
            }
        } else if let filter = filter as? VideoSketchFilter {
            cell.setValue(filter.edgeStrength, min: 0.0, max: 1.0)
            cell.didChange = { value in
                filter.edgeStrength = value
            }
        } else if let filter = filter as? VideoMosaicFilter {
            cell.setValue(Float(filter.displayTileSize.width), min: 0.002, max: 0.05)
            cell.didChange = { value in
                filter.displayTileSize = CGSize(width: CGFloat(value), height: CGFloat(value))
            }
        }
        return cell
    }
    
    @objc private func save() {
        if let filter = filter as? VideoTransformFilter {
            var transform: CGAffineTransform = .identity
            transform = transform.translatedBy(x: CGFloat(translationX), y: CGFloat(translationY))
            transform = transform.scaledBy(x: CGFloat(scaleX), y: CGFloat(scaleY))
            transform = transform.rotated(by: CGFloat(rotationAngle))
            filter.affineTransform = transform
        }
        delegate?.updateFilter(filter, at: index)
    }

}

class SliderCell: UITableViewCell {
    
    private let minLabel = UILabel()
    private let valueLabel = UILabel()
    private let maxLabel = UILabel()
    private let slider = UISlider()
    
    var didChange: ((Float) -> ())?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(minLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(maxLabel)
        contentView.addSubview(slider)

        valueLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.centerY).offset(-2)
        }
        minLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalTo(valueLabel)
        }
        maxLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(valueLabel)
        }
        slider.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(contentView.snp.centerY).offset(2)
        }
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    func setValue(_ value: Float, min: Float, max: Float) {
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = value
        minLabel.text = "\(min)"
        maxLabel.text = "\(max)"
        valueLabel.text = String(format: "%.3f", value)
    }
    
    @objc private func sliderValueChanged(_ slider: UISlider) {
        valueLabel.text = String(format: "%.3f", slider.value)
        didChange?(slider.value)
    }
    
}

class SwitchCell: UITableViewCell {
    
    private let aSwitch = UISwitch()
    
    var didChange: ((Bool) -> ())?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(aSwitch)

        aSwitch.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        aSwitch.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    func setValue(_ isOn: Bool) {
        aSwitch.isOn = isOn
    }
    
    @objc private func valueChanged(_ aSwitch: UISwitch) {
        didChange?(aSwitch.isOn)
    }
    
}

class NumberCell: UITableViewCell {
    
    private let textField = UITextField()
    
    var didChange: ((Float) -> ())?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        textField.keyboardType = .decimalPad
        if #available(iOS 13.0, *) {
            textField.layer.borderColor = UIColor.label.cgColor
        } else {
            textField.layer.borderColor = UIColor.black.cgColor
        }
        textField.layer.borderWidth = 1

        contentView.addSubview(textField)

        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        textField.delegate = self
    }
    
    func setValue(_ value: Float) {
        textField.text = String(format: "%.3f", value)
    }
    
}

extension NumberCell: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let value = Float(text) {
            didChange?(value)
        }
    }
    
}
