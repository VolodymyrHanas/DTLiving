//
//  AddAnimatedStickerFilterViewController.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/29.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit

protocol AddAnimatedStickerFilterViewControllerDelegate: class {
    func addAnimatedStickerFilter(_ filter: VideoAnimatedStickerFilter)
}

class AddAnimatedStickerFilterViewController: UITableViewController {

    weak var delegate: AddAnimatedStickerFilterViewControllerDelegate?

    private let filter: VideoAnimatedStickerFilter

    private let colorSwitch = UISwitch()
    private let imageSegmentedControl = UISegmentedControl()

    private var animateDuration: Float = 5
    private var isRepeat: Bool = false
    private var startScale: Float = 1.0
    private var endScale: Float = 1.0
    private var startRotate: Float = 0
    private var endRotate: Float = 0
    private var startTranslateX: Float = 0
    private var startTranslateY: Float = 0
    private var endTranslateX: Float = 0
    private var endTranslateY: Float = 0
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(filter: VideoAnimatedStickerFilter) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Animated Sticker Filter"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
                
        tableView.rowHeight = 70
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(NumberCell.self, forCellReuseIdentifier: "NumberCell")
        tableView.register(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")
        tableView.register(SliderCell.self, forCellReuseIdentifier: "SliderCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {        
        return 10
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "animateDuration"
        case 1:
            return "isRepeat"
        case 2:
            return "startScale"
        case 3:
            return "endScale"
        case 4:
            return "startRotate"
        case 5:
            return "endRotate"
        case 6:
            return "startTranslateX"
        case 7:
            return "startTranslateY"
        case 8:
            return "endTranslateX"
        default:
            return "endTranslateY"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NumberCell", for: indexPath) as? NumberCell else {
                return UITableViewCell()
            }
            cell.setValue(animateDuration)
            cell.didChange = { [weak self] value in
                self?.animateDuration = value
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as? SwitchCell else {
                return UITableViewCell()
            }
            cell.setValue(isRepeat)
            cell.didChange = { [weak self] value in
                self?.isRepeat = value
            }
            return cell
        default:
            break
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell", for: indexPath) as? SliderCell else {
            return UITableViewCell()
        }

        switch indexPath.section {
        case 2:
            cell.setValue(startScale, min: 0.0, max: 2.0)
            cell.didChange = { [weak self] value in
                self?.startScale = value
            }
        case 3:
            cell.setValue(endScale, min: 0.0, max: 2.0)
            cell.didChange = { [weak self] value in
                self?.endScale = value
            }
        case 4:
            cell.setValue(startRotate, min: 0.0, max: 360)
            cell.didChange = { [weak self] value in
                self?.startRotate = value
            }
        case 5:
            cell.setValue(endRotate, min: 0.0, max: 360)
            cell.didChange = { [weak self] value in
                self?.endRotate = value
            }
        case 6:
            cell.setValue(startTranslateX, min: -360, max: 360)
            cell.didChange = { [weak self] value in
                self?.startTranslateX = value
            }
        case 7:
            cell.setValue(startTranslateY, min: -640, max: 640)
            cell.didChange = { [weak self] value in
                self?.startTranslateY = value
            }
        case 8:
            cell.setValue(endTranslateX, min: -360, max: 360)
            cell.didChange = { [weak self] value in
                self?.endTranslateX = value
            }
        default:
            cell.setValue(endTranslateY, min: -640, max: 640)
            cell.didChange = { [weak self] value in
                self?.endTranslateY = value
            }
        }

        return cell
    }

    @objc private func save() {
        filter.imageName = "walk"
        filter.imageCount = 4
        filter.imageInterval = 1.0 / 24 * 4
        filter.animateDuration = animateDuration
        filter.isRepeat = isRepeat
        filter.startScale = startScale
        filter.endScale = endScale
        filter.startRotate = startRotate
        filter.endRotate = endRotate
        filter.startTranslate = .init(x: startTranslateX, y: startTranslateY)
        filter.endTranslate = .init(x: endTranslateX, y: endTranslateY)
        
        delegate?.addAnimatedStickerFilter(filter)
    }

}
