//
//  AudioNodeLoader.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/30/22.
//

import Foundation

/**
 Loads multiple `AudioNode`s on a background queue to be able to display the
 nodes quickly once they are needed.
*/
class AudioNodeLoader {
    private(set) var loadedNodes = [AudioNode]()
    
    private(set) var isLoading = false
    
    // MARK: - Loading node

    /**
     Loads a `AudioNode` on a background queue. `loadedHandler` is invoked
     on a background queue once `node` has been loaded.
    */
    func loadAudioNode(_ node: AudioNode, loadedHandler: @escaping (AudioNode) -> Void) {
        isLoading = true
        loadedNodes.append(node)
        
        // Load the content into the reference node.
        DispatchQueue.global(qos: .userInitiated).async {
            node.load()
            self.isLoading = false
            loadedHandler(node)
        }
    }
    
    // MARK: - Removing Objects
    
    func removeAllAudioNodes() {
        // Reverse the indices so we don't trample over indices as nodes are removed.
        for index in loadedNodes.indices.reversed() {
            removeAudioNode(at: index)
        }
    }

    /// - Tag: RemoveAudioNode
    func removeAudioNode(at index: Int) {
        guard loadedNodes.indices.contains(index) else { return }
        
        // Stop the node's tracked ray cast.
        loadedNodes[index].stopTrackedRaycast()
        
        // Remove the visual node from the scene graph.
        loadedNodes[index].removeFromParentNode()
        // Recoup resources allocated by the node.
        loadedNodes[index].unload()
        loadedNodes.remove(at: index)
    }
}
