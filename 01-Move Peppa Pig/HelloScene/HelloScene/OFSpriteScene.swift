//
//  OFSpriteScene.swift
//  HelloScene
//
//  Created by anker on 2021/11/25.
//

import UIKit
import SpriteKit

class OFSpriteScene: SKScene {
    var node: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        // 创建一个精灵节点，并添加到场景中
        node = SKSpriteNode(imageNamed: "pig.jpg")
        node?.size = CGSize(width: 150.0, height: 150.0)
        addChild(node!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = self.node else {
            return
        }
        startAnimation(withNode: node)
    }
    
    func startAnimation(withNode node: SKSpriteNode) {
        // 创建一个移动动作
        let moveAction = SKAction.move(to: CGPoint(x: 300, y: 500), duration: 2)
        // 精灵节点运行这个动作
        node.run(moveAction) { [weak self] in
            // 重置精灵节点的位置
            self?.resetPosition()
        }
        
        // 创建一个缩放动作
        let scaleAction = SKAction.scale(to: CGSize(width: 50, height: 50), duration: 2)
        // 精灵节点运行缩放动作
        node.run(scaleAction)
    }
    
    // 重置精灵节点的位置
    func resetPosition() {
        // 创建一个移动动作，让精灵节点返回 （0，0）
        let moveAction = SKAction.move(to: .zero, duration: 2)
        node?.run(moveAction)
        
        // 创建一个缩放动作，让精灵节点缩放到原来的大小
        let scaleAction = SKAction.scale(to: CGSize(width: 150, height: 150), duration: 2)
        node?.run(scaleAction)
    }
}
