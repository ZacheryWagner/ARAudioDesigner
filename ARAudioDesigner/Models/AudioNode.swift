//
//  AudioNode.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/30/22.
//

import Foundation
import SceneKit
import ARKit

class AudioNode: SCNNode {
    
    // MARK: - Properties
    
    /// The object's corresponding ARAnchor.
    var anchor: ARAnchor?

    /// The raycast query used when placing this object.
    var raycastQuery: ARRaycastQuery?
    
    /// The associated tracked raycast used to place this object.
    var raycast: ARTrackedRaycast?
    
    /// The most recent raycast result used for determining the initial location
    /// of the object after placement.
    var mostRecentInitialPlacementResult: ARRaycastResult?
    
    /// Flag that indicates the associated anchor should be updated
    /// at the end of a pan gesture or when the object is repositioned.
    var shouldUpdateAnchor = false

    /// Rotates the first child node of a virtual object.
    /// - Note: For correct rotation on horizontal and vertical surfaces, rotate around
    /// local y rather than world y.
    var objectRotation: Float {
        get {
            return childNodes.first!.eulerAngles.y
        }
        set (newValue) {
            childNodes.first!.eulerAngles.y = newValue
        }
    }
    
    private var audioType: AudioType

    // MARK: - Initialization
    
    init(audioType: AudioType) {
        self.audioType = audioType
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Node Setup
    
    private func setNodeVisuals() {
        
    }
    
    private func setNodeAudio() {
        
    }
    
    // MARK: - Raycasting

    /**
     Stops tracking the object's position and orientation.
        - Tag: StopTrackedRaycasts
     */
    func stopTrackedRaycast() {
        raycast?.stopTracking()
        raycast = nil
    }
    
    // MARK: - Static Methods

    /**
     - Returns: an `AudioNode` if one exists as an ancestor to the provided node.
     */
    static func existingObjectContainingNode(_ node: SCNNode) -> AudioNode? {
        if let virtualObjectRoot = node as? AudioNode {
            return virtualObjectRoot
        }
        
        guard let parent = node.parent else { return nil }
        
        // Recurse up to check if the parent is a `VirtualObject`.
        return existingObjectContainingNode(parent)
    }
}
