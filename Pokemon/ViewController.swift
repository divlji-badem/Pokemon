//
//  ViewController.swift
//  Pokemon
//
//  Created by Jelena Tasic on 8.11.21..
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //add light to scene
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            
            configuration.detectionImages = imagesToTrack
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Images successfuly added!")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - ARSCNViewDelegate
    // finds a card
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(
                width: imageAnchor.referenceImage.physicalSize.width,
                height: imageAnchor.referenceImage.physicalSize.height)
            // make a transparent plane
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -Float.pi/2
            node.addChildNode(planeNode)
            
            if imageAnchor.referenceImage.name == "eevee-card" {
                if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn") {
                    if let pokiNode = pokeScene.rootNode.childNodes.first {
                        //standing on the card
                        pokiNode.eulerAngles.x = .pi/2
                        planeNode.addChildNode(pokiNode)
                    }
                }
            }
            
            if imageAnchor.referenceImage.name == "oddish-card" {
                if let pokeScene = SCNScene(named: "art.scnassets/oddish.scn") {
                    if let pokiNode = pokeScene.rootNode.childNodes.first {
                        //standing on the card
                        pokiNode.eulerAngles.x = .pi/2
                        planeNode.addChildNode(pokiNode)
                    }
                }
            }
        }
        return node
    }
}
