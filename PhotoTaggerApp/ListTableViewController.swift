//
//  ListTableViewController.swift
//  PhotoTaggerApp
//
//  Created by NishiokaKohei on 2017/01/27.
//  Copyright © 2017年 Kohey. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    // MARK: - IBOulets

    // MARK: - Properties
    var data = [AnyObject]()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - UITableViewDataSource
extension ListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellData = data[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TagOrColorCell", for: indexPath)
//        cell.textLabel?.text = cellData.label
//        return cell
//    }

}
