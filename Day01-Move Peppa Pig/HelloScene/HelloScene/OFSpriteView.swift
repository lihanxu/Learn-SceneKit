//
//  OFSpriteView.swift
//  HelloScene
//
//  Created by anker on 2021/11/25.
//

import UIKit
import SpriteKit

class OFSpriteView: SKView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
        let scene = OFSpriteScene(size: bounds.size)
        scene.backgroundColor = .lightGray
        presentScene(scene)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
