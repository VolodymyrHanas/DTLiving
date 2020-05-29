//
//  AddFilterViewController.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/28.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit

protocol AddFilterViewControllerDelegate: class {
    func addFilter(_ filter: VideoFilter)
}

class AddFilterViewController: UITableViewController {
        
    weak var delegate: AddFilterViewControllerDelegate?
    
    private let sections = ["Color Processing", "Image Processing", "Blend", "Composition", "Effect"]
    private let filters: [[VideoFilter]] = [
        [
            VideoBrightnessFilter(),
            VideoExposureFilter(),
            VideoContrastFilter(),
            VideoSaturationFilter(),
            VideoGammaFilter(),
            VideoLevelsFilter(),
            VideoSepiaFilter(),
            VideoRGBFilter(),
            VideoHueFilter(),
            VideoGrayScaleFilter()
        ],
        [
            VideoTransformFilter(),
            VideoCropFilter(),
            VideoGaussianBlurFilter(),
            VideoBoxBlurFilter(),
            VideoSobelEdgeDetectionFilter(),
            VideoSharpenFilter(),
            VideoBilateralFilter()
        ],
        [
            VideoAddBlendFilter(),
            VideoAlphaBlendFilter(),
            VideoMaskFilter(),
            VideoMultiplyBlendFilter(),
            VideoScreenBlendFilter(),
            VideoOverlayBlendFilter(),
            VideoSoftLightFilter(),
            VideoHardLightFilter()
        ],
        [
            VideoWaterMaskFilter(),
            VideoAnimatedStickerFilter(),
            VideoTextFilter()
        ],
        [
            VideoEmbossFilter(),
            VideoToonFilter(),
            VideoSketchFilter(),
            VideoMosaicFilter()
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Filter"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let filter = filters[indexPath.section][indexPath.row]
        cell.textLabel?.text = filter.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let filter = filters[indexPath.section][indexPath.row]
        
        if let filter = filter as? VideoAnimatedStickerFilter {
            let addAnimatedStickerFilterVC = AddAnimatedStickerFilterViewController(filter: filter)
            addAnimatedStickerFilterVC.delegate = self
            navigationController?.pushViewController(addAnimatedStickerFilterVC, animated: true)
            return
        } else if let filter = filter as? VideoTextFilter {
            let addTextFilterVC = AddTextFilterViewController(filter: filter)
            addTextFilterVC.delegate = self
            navigationController?.pushViewController(addTextFilterVC, animated: true)
            return
        } else if let filter = filter as? VideoMosaicFilter {
            let addMosaicFilterVC = AddMosaicFilterViewController(filter: filter)
            addMosaicFilterVC.delegate = self
            navigationController?.pushViewController(addMosaicFilterVC, animated: true)
            return
        }
        
        if let filter = filter as? VideoAddBlendFilter {
            filter.imageName = "colors"
        } else if let filter = filter as? VideoAlphaBlendFilter {
            filter.imageName = "colors"
        } else if let filter = filter as? VideoMaskFilter {
            filter.imageName = "star"
        } else if let filter = filter as? VideoMultiplyBlendFilter {
            filter.imageName = "colors"
        } else if let filter = filter as? VideoScreenBlendFilter {
            filter.imageName = "colors"
        } else if let filter = filter as? VideoOverlayBlendFilter {
            filter.imageName = "colors"
        } else if let filter = filter as? VideoSoftLightFilter {
            filter.imageName = "colors"
        } else if let filter = filter as? VideoHardLightFilter {
            filter.imageName = "colors"
        } else if let filter = filter as? VideoWaterMaskFilter {
            filter.imageName = "logo"
        }
        delegate?.addFilter(filter)
    }

}

extension AddFilterViewController: AddAnimatedStickerFilterViewControllerDelegate {

    func addAnimatedStickerFilter(_ filter: VideoAnimatedStickerFilter) {
        delegate?.addFilter(filter)
    }

}

extension AddFilterViewController: AddTextFilterViewControllerDelegate {
    
    func addTextFilter(_ filter: VideoTextFilter) {
        delegate?.addFilter(filter)
    }    
    
}

extension AddFilterViewController: AddMosaicFilterViewControllerDelegate {
    
    func addMosaicFilter(_ filter: VideoMosaicFilter) {
        delegate?.addFilter(filter)
    }
    
}
