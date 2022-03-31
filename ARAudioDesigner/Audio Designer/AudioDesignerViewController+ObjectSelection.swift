//
//  AudioDesignerViewController+ObjectSelection.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/30/22.
//

import ARKit

extension AudioDesignerViewController: AudioNodeSelectionViewControllerDelegate {
    
    /** Adds the specified virtual node to the scene, placed at the world-space position
     estimated by a hit test from the center of the screen.
     - Tag: PlaceAudioNode */
    func placeAudioNode(_ audioNode: AudioNode) {
        guard focusSquare.state != .initializing, let query = audioNode.raycastQuery else {
            self.statusViewController.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
            if let controller = self.nodeSelectionViewController {
                self.audioNodeSelectionViewController(controller, didDeselectObject: audioNode)
            }
            return
        }
       
        let trackedRaycast = createTrackedRaycastAndSet3DPosition(of: audioNode, from: query,
                                                                  withInitialResult: audioNode.mostRecentInitialPlacementResult)
        
        audioNode.raycast = trackedRaycast
        audioNodeInteraction.selectedObject = audioNode
        audioNode.isHidden = false
    }
    
    // - Tag: GetTrackedRaycast
    func createTrackedRaycastAndSet3DPosition(of audioNode: AudioNode, from query: ARRaycastQuery,
                                              withInitialResult initialResult: ARRaycastResult? = nil) -> ARTrackedRaycast? {
        if let initialResult = initialResult {
            self.setTransform(of: audioNode, with: initialResult)
        }
        
        return session.trackedRaycast(query) { (results) in
            self.setAudioNode3DPosition(results, with: audioNode)
        }
    }
    
    func createRaycastAndUpdate3DPosition(of audioNode: AudioNode, from query: ARRaycastQuery) {
        guard let result = session.raycast(query).first else {
            return
        }
        
        if audioNodeInteraction.trackedObject == audioNode {
            
            // If an node that's aligned to a surface is being dragged, then
            // smoothen its orientation to avoid visible jumps, and apply only the translation directly.
            audioNode.simdWorldPosition = result.worldTransform.translation
            
            let previousOrientation = audioNode.simdWorldTransform.orientation
            let currentOrientation = result.worldTransform.orientation
            audioNode.simdWorldOrientation = simd_slerp(previousOrientation, currentOrientation, 0.1)
        } else {
            self.setTransform(of: audioNode, with: result)
        }
    }
    
    // - Tag: ProcessRaycastResults
    private func setAudioNode3DPosition(_ results: [ARRaycastResult], with audioNode: AudioNode) {
        
        guard let result = results.first else {
            fatalError("Unexpected case: the update handler is always supposed to return at least one result.")
        }
        
        self.setTransform(of: audioNode, with: result)
        
        // If the virtual node is not yet in the scene, add it.
        if audioNode.parent == nil {
            self.sceneView.scene.rootNode.addChildNode(audioNode)
            audioNode.shouldUpdateAnchor = true
        }
        
        if audioNode.shouldUpdateAnchor {
            audioNode.shouldUpdateAnchor = false
            self.updateQueue.async {
                self.sceneView.addOrUpdateAnchor(for: audioNode)
            }
        }
    }
    
    func setTransform(of audioNode: AudioNode, with result: ARRaycastResult) {
        audioNode.simdWorldTransform = result.worldTransform
    }

    // MARK: - AudioNodeSelectionViewControllerDelegate
    // - Tag: PlaceVirtualContent
    func audioNodeSelectionViewController(_: AudioNodeSelectionViewController, didSelectObject node: AudioNode) {
        audioNodeLoader.loadAudioNode(node, loadedHandler: { [unowned self] loadedObject in
            
//            do {
//                let scene = try SCNScene(url: node.referenceURL, options: nil)
//                self.sceneView.prepare([scene], completionHandler: { _ in
//                    DispatchQueue.main.async {
//                        self.hideObjectLoadingUI()
//                        self.placeAudioNode(loadedObject)
//                    }
//                })
//            } catch {
//                fatalError("Failed to load SCNScene from node.referenceURL")
//            }
//            
//        })

        displayObjectLoadingUI()
    }
    
    func audioNodeSelectionViewController(_: AudioNodeSelectionViewController, didDeselectObject node: AudioNode) {
        guard let nodeIndex = audioNodeLoader.loadedNodes.firstIndex(of: node) else {
            fatalError("Programmer error: Failed to lookup virtual node in scene.")
        }
        audioNodeLoader.removeAudioNode(at: nodeIndex)
        audioNodeInteraction.selectedObject = nil
        if let anchor = node.anchor {
            session.remove(anchor: anchor)
        }
    }

    // MARK: Object Loading UI

    func displayObjectLoadingUI() {
        // Show progress indicator.
        spinner.startAnimating()
        
        addObjectButton.setImage(#imageLiteral(resourceName: "buttonring"), for: [])

        addObjectButton.isEnabled = false
        isRestartAvailable = false
    }

    func hideObjectLoadingUI() {
        // Hide progress indicator.
        spinner.stopAnimating()

        addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
        addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])

        addObjectButton.isEnabled = true
        isRestartAvailable = true
    }
}
