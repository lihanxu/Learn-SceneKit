//
//  ViewController.swift
//  HelloScene
//
//  Created by anker on 2021/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    var spriteView: OFSpriteView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spriteView = OFSpriteView(frame: self.view.bounds)
        view.addSubview(spriteView!)
    }


}

