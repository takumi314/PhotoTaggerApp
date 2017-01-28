//
//  TagsColorsShowViewController.swift
//  PhotoTaggerApp
//
//  Created by NishiokaKohei on 2017/01/27.
//  Copyright © 2017年 Kohey. All rights reserved.
//

import UIKit

class TagsColorsViewController: UIViewController {

    // MARK: - Properties
    var tags: [String]?
    var colors: [PhotoColor]?
    var tableViewController: ListTableViewController?

    // MARK: - IBOutlets
    @IBOutlet var segmentedControl: UISegmentedControl!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableData()
    }

    // MARK: - Navigation
    // 画面遷移

    // MARK: - IBActions
    @IBAction func tagsColorsSegmentedControlChanged(_ sender: UISegmentedControl) {
        setupTableData()
    }

    // MARK: - Public

    // MARK: - Private
    private func setupTableData() {
        if segmentedControl.selectedSegmentIndex == 0 {
            setupTableDataOfTags()
        } else {
            setupTableDataOfColors()
        }
        tableViewController?.tableView.reloadData()
    }

    private func setupTableDataOfTags() {
        if let tags = tags {
            tableViewController?.data = tags.map {
                TagsColorTableData(label: $0, color: nil)
            }
        } else {
            tableViewController?.data = [TagsColorTableData(label: "No tags were fetched.", color: nil)]
        }
    }

    private func setupTableDataOfColors() {
        if let colors = colors {
            tableViewController?.data
                = colors.map({ (photoColor: PhotoColor) -> TagsColorTableData in
                    let uicolor = UIColor(red: CGFloat(photoColor.red!) / 255,
                                          green: CGFloat(photoColor.green!) / 255,
                                          blue: CGFloat(photoColor.blue!) / 255,
                                          alpha: 1.0)
                    return TagsColorTableData(label: photoColor.colorName!, color: uicolor)
                })
        } else {
            tableViewController?.data = [TagsColorTableData(label: "No colors were fetched.", color: nil)]
        }
    }

}
