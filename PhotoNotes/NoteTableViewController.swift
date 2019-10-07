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
    
    var notes = UserDefaults.standard.dictionary(forKey: "notes") as? [String: String] ?? [:] {
        didSet {
            UserDefaults.standard.set(notes, forKey: "notes")
        }
    }
    lazy var assets: PHFetchResult<PHAsset> = {
        let options = PHFetchOptions()
        options.sortDescriptors = [.init(key: "creationDate", ascending: false)]
        return PHAsset.fetchAssets(with: options)
    }()

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
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
            PHImageManager.default().requestImage(for: asset, targetSize: .init(width: 30, height: 30), contentMode: .aspectFill, options: nil) { image, info in
                guard cell.id == asset.localIdentifier else { return }
                cell.imageView?.image = image
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            }
        }
        
        return cell
    }
    
    fileprivate func makeNoteViewController(asset: PHAsset) -> UIViewController? {
        guard let noteVC = storyboard?.instantiateViewController(identifier: "NoteViewController") as? NoteViewController else { return nil }
        noteVC.id = asset
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
        return noteVC
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "PresentNoteVC":
            guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell),
                let pageVC = segue.destination as? UIPageViewController else { return }
            
            let asset = assets.object(at: indexPath.row)
            guard let noteVC = makeNoteViewController(asset: asset) else { return }
            pageVC.setViewControllers([noteVC], direction: .forward, animated: false)
            pageVC.dataSource = self
            pageVC.view.backgroundColor = .systemBackground
            
        default:
            break
        }
    }
}


extension NoteTableViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let noteVC = viewController as? NoteViewController,
            let asset = noteVC.id as? PHAsset else { return nil }
        let index = assets.index(of: asset)
        guard index != NSNotFound else { return nil }
        let newIndex = index - 1
        guard newIndex >= 0 else { return nil }
        let newAsset = assets.object(at: newIndex)
        return makeNoteViewController(asset: newAsset)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let noteVC = viewController as? NoteViewController,
            let asset = noteVC.id as? PHAsset else { return nil }
        let index = assets.index(of: asset)
        guard index != NSNotFound else { return nil }
        let newIndex = index + 1
        guard newIndex < assets.count else { return nil }
        let newAsset = assets.object(at: newIndex)
        return makeNoteViewController(asset: newAsset)
    }
}
