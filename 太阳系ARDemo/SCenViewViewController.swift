//
//  SCenViewViewController.swift
//  太阳系ARDemo
//
//  Created by 韩云智 on 2017/10/2.
//  Copyright © 2017年 韩云智. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class SCenViewViewController: UIViewController, ARSCNViewDelegate {
    
    var arSCNView: ARSCNView?
    lazy var arSession: ARSession = ARSession.init()
    var arSessionConfiguation: ARConfiguration?
    
    lazy var sunNode: SCNNode = {
        let sunNode = SCNNode.init()
        sunNode.geometry = SCNSphere.init(radius: 3)
        sunNode.geometry?.firstMaterial?.multiply.contents = "art.scnassets/earth/sun.jpg"
        sunNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/sun.jpg"
        sunNode.geometry?.firstMaterial?.multiply.intensity = 0.5
        sunNode.geometry?.firstMaterial?.lightingModel = .constant
        sunNode.position = SCNVector3Make(0, 5, -25)
        sunNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: 2, around: SCNVector3Make(0.1, 1, 0), duration: 1)))
        
        let earthRotationNode = SCNNode.init()
        earthRotationNode.geometry = SCNTorus.init(ringRadius: 10, pipeRadius: 0.025)
        earthRotationNode.geometry?.firstMaterial?.multiply.contents = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        earthRotationNode.geometry?.firstMaterial?.diffuse.contents = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        earthRotationNode.position = SCNVector3Make(0, 5, -25)
        earthRotationNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: 1, around: SCNVector3Make(0, 1, 0), duration: 1)))
        arSCNView?.scene.rootNode.addChildNode(earthRotationNode)
        
        earthRotationNode.addChildNode(earthGroupNode)
        
        return sunNode
    }()
    lazy var moonNode: SCNNode = {
        let moonNode = SCNNode.init()
        
        moonNode.geometry = SCNSphere.init(radius: 0.3)
        
        moonNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/moon.jpg"
        
        moonNode.geometry?.firstMaterial?.specular.contents = UIColor.gray
        
        moonNode.position = SCNVector3Make(2, 0, 0)
        
        moonNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: 5, around: SCNVector3Make(0.2, 2, 0), duration: 1)))
        
        return moonNode
    }()
    lazy var earthNode: SCNNode = {
        let earthNode = SCNNode.init()
        earthNode.geometry = SCNSphere.init(radius: 1)
        earthNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/earth-diffuse-mini.jpg"
        earthNode.geometry?.firstMaterial?.emission.contents = "art.scnassets/earth/earth-emissive-mini.jpg"
        earthNode.geometry?.firstMaterial?.specular.contents = "art.scnassets/earth/earth-specular-mini.jpg"
        
        earthNode.geometry?.firstMaterial?.shininess = 0.1; // 光泽
        earthNode.geometry?.firstMaterial?.specular.intensity = 0.5; // 反射多少光出去
        
        earthNode.position = SCNVector3Make(0, 0, 0)
        earthNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: 3, around: SCNVector3Make(1, sqrt(3), 0), duration: 1)))
        return earthNode
    }()
    
    lazy var earthGroupNode: SCNNode = {
        
        let earthGroupNode = SCNNode.init()
        earthGroupNode.position = SCNVector3Make(10, 0, 0)
        earthGroupNode.addChildNode(earthNode)
        
        let moonRotationNode = SCNNode.init()
        moonRotationNode.geometry = SCNTorus.init(ringRadius: 2, pipeRadius: 0.01)
//        moonRotationNode.geometry?.firstMaterial?.multiply.contents = UIColor.clear
        moonRotationNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        moonRotationNode.position = SCNVector3Make(0, 0, 0)
        moonRotationNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: 5, around: SCNVector3Make(0, 1, 0), duration: 1)))
        earthGroupNode.addChildNode(moonRotationNode)
        
        moonRotationNode.addChildNode(moonNode)
        
        return earthGroupNode
    }()
    lazy var sunHaloNode: SCNNode = {
        
        let lightNode = SCNNode.init()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3Zero
        lightNode.light?.color = UIColor.white
        lightNode.light?.attenuationEndDistance = 30.0
        lightNode.light?.attenuationStartDistance = 1.0
        sunNode.addChildNode(lightNode)
        
        let sunHaloNode = SCNNode.init()
        sunHaloNode.geometry = SCNPlane.init(width: 25, height: 25)
        sunHaloNode.rotation = SCNVector4Make(1, 0, 0, 0 * .pi / 180.0)
        sunHaloNode.position = SCNVector3Make(0, 5, -25)
        sunHaloNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/sun-halo.png"
        sunHaloNode.geometry?.firstMaterial?.lightingModel = .constant
        sunHaloNode.geometry?.firstMaterial?.writesToDepthBuffer = false
        sunHaloNode.opacity = 0.5
        
        return sunHaloNode
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        arSessionConfiguation = ARWorldTrackingConfiguration.init()
        arSessionConfiguation?.isLightEstimationEnabled = true
        arSession.run(arSessionConfiguation!, options: [.resetTracking,.removeExistingAnchors])
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        arSCNView = ARSCNView.init(frame: view.bounds)
        arSCNView?.session = self.arSession
        arSCNView?.automaticallyUpdatesLighting = true
        initNode()
        view.addSubview(arSCNView!)
        arSCNView?.delegate = self
    }
    
    func initNode() {
        arSCNView?.scene.rootNode.addChildNode(sunNode)
        arSCNView?.scene.rootNode.addChildNode(sunHaloNode)
    }
}
