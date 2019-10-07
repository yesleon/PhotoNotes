//
//  NoteViewController.swift
//  PhotoNotes
//
//  Created by Li-Heng Hsu on 2019/10/7.
//  Copyright © 2019 Li-Heng Hsu. All rights reserved.
//

import UIKit



class NoteViewController: UIViewController {
    
    var pagesContext: Context<(Int) -> UIViewController?>!
    var noteContext: MutableContext<String?>!
    var imageContext: AsynchronousContext<UIImage?>!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteContext { [weak textView] in textView?.text = $0 }
        imageContext { [weak imageView] in
            imageView?.image = $0 == nil ? imageView?.image : $0
            
        }
        
        textView.delegate = self
    }
}

extension NoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        noteContext { $0 = textView.text }
    }
}
