//
//  NoteTableViewController.swift
//  PhotoNotes
//
//  Created by Li-Heng Hsu on 2019/10/7.
//  Copyright © 2019 Li-Heng Hsu. All rights reserved.
//

import UIKit
import Photos

class NoteTableViewController: UITableViewController {
    
    var notes = [String: String]()
    lazy var assets = PHAsset.fetchAssets(with: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return assets.count
    }
    
    

}
