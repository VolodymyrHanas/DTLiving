//
//  FiltersViewController.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/28.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit

class FiltersViewController: UITableViewController {
    
    private let liveManager: LiveManager
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(liveManager: LiveManager) {
        self.liveManager = liveManager
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        title = "Filters"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clear))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveManager.numberOfFilters
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let filter = liveManager.fetchFilter(at: indexPath.row)
        cell.textLabel?.text = filter.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let filter = liveManager.fetchFilter(at: indexPath.row)
        if !(filter is VideoSepiaFilter
            || filter is VideoGrayScaleFilter
            || filter is VideoAddBlendFilter
            || filter is VideoMaskFilter
            || filter is VideoMultiplyBlendFilter
            || filter is VideoScreenBlendFilter
            || filter is VideoOverlayBlendFilter
            || filter is VideoSoftLightFilter
            || filter is VideoHardLightFilter
            || filter is VideoAnimatedStickerFilter) {
            let updateFilterVC = UpdateFilterViewController(filter: filter, index: indexPath.row)
            updateFilterVC.delegate = self
            self.navigationController?.pushViewController(updateFilterVC, animated: true)
        }
    }
    
    @objc private func clear() {
        liveManager.clearAllFilters()
        tableView.reloadData()
    }
    
    @objc private func add() {
        let addFilterVC = AddFilterViewController()
        addFilterVC.delegate = self
        self.navigationController?.pushViewController(addFilterVC, animated: true)
    }

}

extension FiltersViewController: AddFilterViewControllerDelegate {
    
    func addFilter(_ filter: VideoFilter) {
        self.navigationController?.popToRootViewController(animated: true)
        liveManager.addFilter(filter)
        tableView.reloadData()
    }
    
}

extension FiltersViewController: UpdateFilterViewControllerDelegate {
    
    func updateFilter(_ filter: VideoFilter, at index: Int) {
        self.navigationController?.popViewController(animated: true)
        liveManager.updateFilter(filter, at: index)
    }
    
}
