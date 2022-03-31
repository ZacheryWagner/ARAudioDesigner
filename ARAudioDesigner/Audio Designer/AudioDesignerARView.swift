//
//  AudioDesignerARView.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/29/22.
//

import Foundation
import ARKit

class AudioDesignerARView: ARSCNView {

    // MARK: Position Testing
    
    /// Hit tests against the `sceneView` to find an node at the provided point.
    func audioNode(at point: CGPoint) -> AudioNode? {
        let hitTestOptions: [SCNHitTestOption: Any] = [.boundingBoxOnly: true]
        let hitTestResults = hitTest(point, options: hitTestOptions)
        
        return hitTestResults.lazy.compactMap { result in
            return AudioNode.existingObjectContainingNode(result.node)
        }.first
    }
    
    // - MARK: Object anchors
    /// - Tag: AddOrUpdateAnchor
    func addOrUpdateAnchor(for node: AudioNode) {
        // If the anchor is not nil, remove it from the session.
        if let anchor = node.anchor {
            session.remove(anchor: anchor)
        }
        
        // Create a new anchor with the node's current transform and add it to the session
        let newAnchor = ARAnchor(transform: node.simdWorldTransform)
        node.anchor = newAnchor
        session.add(anchor: newAnchor)
    }
}
