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
        
        assets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let asset = assets.object(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell as? NoteTableViewCell).map { cell in
            cell.id = asset.localIdentifier
            cell.textLabel?.text = notes[asset.localIdentifier]
            cell.imageView?.image = nil
            PHImageManager.default().requestImage(for: asset, targetSize: .init(width: 30, height: 30), contentMode: .aspectFill, options: nil) { image, info in
                guard cell.id == asset.localIdentifier else { return }
                cell.imageView?.image = image
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "PresentNoteVC":
            guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell),
                let noteVC = segue.destination as? NoteViewController else { return }
            let asset = assets.object(at: indexPath.row)
            noteVC.noteContext = { [weak self] handler in
                guard let self = self else { return }
                handler(&self.notes[asset.localIdentifier])
                let indexPath = IndexPath(row: self.assets.index(of: asset), section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            noteVC.imageContext = { handler in
                PHImageManager.default().requestImage(for: asset, targetSize: .init(width: 300, height: 300), contentMode: .aspectFill, options: nil) { image, info in
                    handler(image)
                }
            }
        default:
            break
        }
    }
}
