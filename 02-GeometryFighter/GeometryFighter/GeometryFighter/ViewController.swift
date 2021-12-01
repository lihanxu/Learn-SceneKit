//
//  ViewController.swift
//  GeometryFighter
//
//  Created by anker on 2021/12/1.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    var spawnTime: TimeInterval = 0
    
    var game = GameHelper.sharedInstance
    var splashNodes: [String: SCNNode] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupScene()
        setupCamera()
        setupHUD()
        setupSplash()
//        setupSounds()
    }

    private func setupView() {
        scnView = (self.view as! SCNView)
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnView.isPlaying = true
//        scnView.showsStatistics = true
//        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.delegate = self
    }
    
    private func setupScene() {
        scnScene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }

    private func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    private func spawnShape() {
        let height: CGFloat = CGFloat(Float.random(min: 1.0, max: 2.0))
        let raidus: CGFloat = CGFloat(Float.random(min: 0.3, max: 0.7))
        let geometry: SCNGeometry
        switch ShapeType.random() {
        case .box:
            geometry = SCNBox(width: 1.0, height: height, length: 1.0, chamferRadius: 0.0)
        case .sphere:
            geometry = SCNSphere(radius: raidus)
        case .pyramid:   //金字塔
            geometry = SCNPyramid(width: 1.0, height: height, length: 1.0)
        case .torus:     //环面
            geometry = SCNTorus(ringRadius: raidus, pipeRadius: 0.25)
        case .capsule:  //胶囊
            geometry = SCNCapsule(capRadius:raidus, height: height)
        case .cylinder: //圆筒
            geometry = SCNCylinder(radius: raidus, height: height)
        case .cone: //锥体
            geometry = SCNCone(topRadius: 0.2, bottomRadius: raidus, height: height)
        case .tube: //管子
            geometry = SCNTube(innerRadius: 0.25, outerRadius: raidus, height: height)
        }
        
        let color = UIColor.random
        geometry.materials.first?.diffuse.contents = color
        
        let geometryNode = SCNNode(geometry: geometry)
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        // 添加粒子系统
        if let particle = createTrail(color: color, geometry: geometry) {
            geometryNode.addParticleSystem(particle)
        }
        // 添加名字
        if color == .black {
            geometryNode.name = "BAD"
            game.playSound(scnScene.rootNode, name: PlaySounds.SpawnBad.rawValue)
        } else {
            geometryNode.name = "GOOD"
            game.playSound(scnScene.rootNode, name: PlaySounds.SpawnGood.rawValue)
        }
        // 给物理体施加力
        let randomX = Float.random(min: -2, max: 2)
        let randomY = Float.random(min: 10, max: 18)
        let force = SCNVector3(x: randomX, y: randomY, z: 0)
        let position = SCNVector3(x: 0, y: 0, z: 0)
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        geometryNode.physicsBody?.applyTorque(SCNVector4(x: 0.05, y: 0.05, z: 0.05, w: 1.0), asImpulse: true)
        
        scnScene.rootNode.addChildNode(geometryNode)
    }
    
    private func cleanShape() {
        for node in scnScene.rootNode.childNodes {
            if node.presentation.position.y < -2 {
                node.removeFromParentNode()
            }
        }
    }
    
    private func createTrail(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem? {
        let particle = SCNParticleSystem(named: "trail.scnp", inDirectory: nil)
        particle?.particleColor = color
        particle?.emitterShape = geometry
        return particle
    }
    
    private func createExplosion(geometry: SCNGeometry, position: SCNVector3, rotation: SCNVector4) {
        guard let explosion = SCNParticleSystem(named: "explosion.scnp", inDirectory: nil) else {
            return
        }
        explosion.emitterShape = geometry
        explosion.birthLocation = .surface
        
        let rotationMatrix = SCNMatrix4MakeRotation(rotation.w, rotation.x, rotation.y, rotation.z)
        let translationMatrix = SCNMatrix4MakeTranslation(position.x, position.y, position.z)
        let transformMatrix = SCNMatrix4Mult(rotationMatrix, translationMatrix)
        
        scnScene.addParticleSystem(explosion, transform: transformMatrix)
    }
    
    private func setupHUD() {
        game.hudNode.position = SCNVector3(x: 0, y: 10, z: 0)
        scnScene.rootNode.addChildNode(game.hudNode)
    }
    
    private func setupSplash() {
        splashNodes["TapToPlay"] = createSplash(name: "TapToPlay", imageName: "GeometryFighter.scnassets/Textures/TapToPlay_Diffuse.png")
        splashNodes["GameOver"] = createSplash(name: "GameOver", imageName: "GeometryFighter.scnassets/Textures/GameOver.png")
        showSplash("TapToPlay")
    }
    
//    private func setupSounds() {
//        game.loadSound("ExplodeBad", fileNamed: "GeometryFighter.scnassets/Sounds/ExplodeBad.wav")
//        game.loadSound("ExplodeGood", fileNamed: "GeometryFighter.scnassets/Sounds/ExplodeGood.wav")
//        game.loadSound("GameOver", fileNamed: "GeometryFighter.scnassets/Sounds/GameOver.wav")
//        game.loadSound("SpawnBad", fileNamed: "GeometryFighter.scnassets/Sounds/SpawnBad.wav")
//        game.loadSound("SpawnGood", fileNamed: "GeometryFighter.scnassets/Sounds/SpawnGood.wav")
//    }

    private func createSplash(name: String, imageName: String) -> SCNNode {
        let plane = SCNPlane(width: 5, height: 5)
        let splashNode = SCNNode(geometry: plane)
        splashNode.position = SCNVector3(x: 0, y: 5, z: 0)
        splashNode.name = name
        splashNode.geometry?.materials.first?.diffuse.contents = imageName
        scnScene.rootNode.addChildNode(splashNode)
        return splashNode
    }
    
    private func showSplash(_ splashName: String) {
        for (name, node) in splashNodes {
            if name == splashName {
                node.isHidden = false
            } else {
                node.isHidden = true
            }
        }
    }
    
    private func handleTouchFor(node: SCNNode) {
        if node.name == "GOOD" {
            game.score += 1
            game.playSound(scnScene.rootNode, name: PlaySounds.ExplodeGood.rawValue)
        } else if node.name == "BAD" {
            game.lives -= 1
            game.playSound(scnScene.rootNode, name: PlaySounds.ExplodeBad.rawValue)
            game.shakeNode(cameraNode)
            
            if game.lives <= 0 {
                game.saveState()
                game.playSound(scnScene.rootNode, name: PlaySounds.GameOver.rawValue)
                showSplash("GameOver")
                game.state = .gameOver
                scnScene.rootNode.runAction(SCNAction.waitForDurationThenRunBlock(5.0) { [weak self] node in
                    self?.showSplash("TapToPlay")
                    self?.game.state = .tapToPlay
                })
            }
        }
        createExplosion(geometry: node.geometry!, position: node.presentation.position, rotation: node.presentation.rotation)
        node.removeFromParentNode()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if game.state == .gameOver {
            return
        }
        if game.state == .tapToPlay {
            game.reset()
            game.state = .playing
            showSplash("")
            return
        }
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: scnView)
        let result = scnView.hitTest(location, options:nil)
        guard let res = result.first else {
            return
        }
        if res.node.name == "HUD" ||
            res.node.name == "GameOver" ||
            res.node.name == "TapToPlay" {
            return
        } else {
            handleTouchFor(node: res.node)
        }
    }
}

extension ViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if game.state == .playing {
            if time > spawnTime {
                spawnShape()
                spawnTime = time + TimeInterval(Float.random(min: 0.2, max: 1.5))
            }
            cleanShape()
        }
        game.updateHUD()
    }
}

