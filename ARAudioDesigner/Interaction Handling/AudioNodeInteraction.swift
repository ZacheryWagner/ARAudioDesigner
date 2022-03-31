//
//  AudioNodeInteraction.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/30/22.
//

import Foundation
import UIKit
import ARKit

/**
 Manages user interaction with virtual nodes to enable one-finger tap, one- and two-finger pan,
    and two-finger rotation gesture recognizers to let the user position and orient virtual nodes.
*/

/// - Tag: AudioNodeInteraction
class AudioNodeInteraction: NSObject, UIGestureRecognizerDelegate {
    
    // MARK: Class Properties
    
    /// Developer setting to translate assuming the detected plane extends infinitely.
    let translateAssumingInfinitePlane = true
    
    /// The scene view to hit test against when moving virtual content.
    let sceneView: AudioDesignerARView
    
    /// A reference to the view controller.
    let audioDesignerViewController: AudioDesignerViewController
    
    
    /// The node that has been most recently intereacted with.
    /// The `selectedObject` can be moved at any time with the tap gesture.
    var selectedObject: AudioNode?
    
    /// The node that is tracked for use by the pan and rotation gestures.
    var trackedObject: AudioNode? {
        didSet {
            guard trackedObject != nil else { return }
            selectedObject = trackedObject
        }
    }
    
    /// The tracked screen position used to update the `trackedObject`'s position.
    private var currentTrackingPosition: CGPoint?
    
    // MARK: - Initialization
    
    init(sceneView: AudioDesignerARView, audioDesignerViewController: AudioDesignerViewController) {
        self.sceneView = sceneView
        self.audioDesignerViewController = audioDesignerViewController
        super.init()
        
        createPanGestureRecognizer(sceneView)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGesture.delegate = self
        sceneView.addGestureRecognizer(rotationGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    // - Tag: CreatePanGesture
    func createPanGestureRecognizer(_ sceneView: AudioDesignerARView) {
        let panGesture = ThresholdPanGesture(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        sceneView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Gesture Actions
    
    @objc func didPan(_ gesture: ThresholdPanGesture) {
        switch gesture.state {
        case .began:
            // Check for an node at the touch location.
            if let node = nodeInteracting(with: gesture, in: sceneView) {
                trackedObject = node
            }
            
        case .changed where gesture.isThresholdExceeded:
            guard let node = trackedObject else { return }
            // Move an node if the displacment threshold has been met.
            translate(node, basedOn: updatedTrackingPosition(for: node, from: gesture))

            gesture.setTranslation(.zero, in: sceneView)
            
        case .changed:
            // Ignore the pan gesture until the displacment threshold is exceeded.
            break
            
        case .ended:
            // Update the node's position when the user stops panning.
            guard let node = trackedObject else { break }
            setDown(node, basedOn: updatedTrackingPosition(for: node, from: gesture))
            
            fallthrough
            
        default:
            // Reset the current position tracking.
            currentTrackingPosition = nil
            trackedObject = nil
        }
    }
    
    func updatedTrackingPosition(for node: AudioNode, from gesture: UIPanGestureRecognizer) -> CGPoint {
        let translation = gesture.translation(in: sceneView)
        
        let currentPosition = currentTrackingPosition ?? CGPoint(sceneView.projectPoint(node.position))
        let updatedPosition = CGPoint(x: currentPosition.x + translation.x, y: currentPosition.y + translation.y)
        currentTrackingPosition = updatedPosition
        return updatedPosition
    }

    /**
     For looking down on the node (99% of all use cases), you subtract the angle.
     To make rotation also work correctly when looking from below the node one would have to
     flip the sign of the angle depending on whether the node is above or below the camera.
     - Tag: didRotate */
    @objc func didRotate(_ gesture: UIRotationGestureRecognizer) {
        guard gesture.state == .changed else { return }
        
        trackedObject?.nodeRotation -= Float(gesture.rotation)
        
        gesture.rotation = 0
    }
    
    /// Handles the interaction when the user taps the screen.
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: sceneView)
        
        if let tappedObject = sceneView.audioNode(at: touchLocation) {
            
            // If an node exists at the tap location, select it.
            selectedObject = tappedObject
        } else if let node = selectedObject {
            
            // Otherwise, move the selected node to its new position at the tap location.
            setDown(node, basedOn: touchLocation)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow nodes to be translated and rotated at the same time.
        return true
    }

    /** A helper method to return the first node that is found under the provided `gesture`s touch locations.
     Performs hit tests using the touch locations provided by gesture recognizers. By hit testing against the bounding
     boxes of the virtual nodes, this function makes it more likely that a user touch will affect the node even if the
     touch location isn't on a point where the node has visible content. By performing multiple hit tests for multitouch
     gestures, the method makes it more likely that the user touch affects the intended node.
      - Tag: TouchTesting
    */
    private func nodeInteracting(with gesture: UIGestureRecognizer, in view: ARSCNView) -> AudioNode? {
        for index in 0..<gesture.numberOfTouches {
            let touchLocation = gesture.location(ofTouch: index, in: view)
            
            // Look for an node directly under the `touchLocation`.
            if let node = sceneView.audioNode(at: touchLocation) {
                return node
            }
        }
        
        // As a last resort look for an node under the center of the touches.
        if let center = gesture.center(in: view) {
            return sceneView.audioNode(at: center)
        }
        
        return nil
    }
    
    // MARK: - Update node position

    /// - Tag: DragAudioNode
    func translate(_ node: AudioNode, basedOn screenPos: CGPoint) {
        node.stopTrackedRaycast()
        
        // Update the node by using a one-time position request.
        if let query = sceneView.raycastQuery(
            from: screenPos,
            allowing: .estimatedPlane,
            alignment: .any
        ) {
            audioDesignerViewController.createRaycastAndUpdate3DPosition(of: node, from: query)
        }
    }
    
    func setDown(_ node: AudioNode, basedOn screenPos: CGPoint) {
        node.stopTrackedRaycast()
        
        // Prepare to update the node's anchor to the current location.
        node.shouldUpdateAnchor = true
        
        // Attempt to create a new tracked raycast from the current location.
        if let query = sceneView.raycastQuery(from: screenPos, allowing: .estimatedPlane, alignment: .any),
           let raycast = audioDesignerViewController.createTrackedRaycastAndSet3DPosition(of: node, from: query) {
            node.raycast = raycast
        } else {
            // If the tracked raycast did not succeed, simply update the anchor to the node's current position.
            node.shouldUpdateAnchor = false
            audioDesignerViewController.updateQueue.async {
                self.sceneView.addOrUpdateAnchor(for: node)
            }
        }
    }
}

/// Extends `UIGestureRecognizer` to provide the center point resulting from multiple touches.
extension UIGestureRecognizer {
    func center(in view: UIView) -> CGPoint? {
        guard numberOfTouches > 0 else { return nil }
        
        let first = CGRect(origin: location(ofTouch: 0, in: view), size: .zero)

        let touchBounds = (1..<numberOfTouches).reduce(first) { touchBounds, index in
            return touchBounds.union(CGRect(origin: location(ofTouch: index, in: view), size: .zero))
        }

        return CGPoint(x: touchBounds.midX, y: touchBounds.midY)
    }
}
