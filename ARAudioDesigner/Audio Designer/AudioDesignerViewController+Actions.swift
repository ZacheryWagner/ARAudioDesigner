//
//  AudioDesignerViewController+Actions.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/30/22.
//

import UIKit
import SceneKit

/**
 UI Actions for `AudioDesignerViewController`
 */
extension AudioDesignerViewController: UIGestureRecognizerDelegate {
    
    enum SegueIdentifier: String {
        case showObjects
    }
    
    // MARK: - Interface Actions
    
    /// Displays the `AudioNodeSelectionViewController` from the `addObjectButton` or in response to a tap gesture in the `sceneView`.
    @IBAction func showAudioNodeSelectionViewController() {
        // Ensure adding nodes is an available action and we are not loading another node (to avoid concurrent modifications of the scene).
        guard !addObjectButton.isHidden && !audioNodeLoader.isLoading else { return }
        
        statusViewController.cancelScheduledMessage(for: .contentPlacement)
        performSegue(withIdentifier: SegueIdentifier.showObjects.rawValue, sender: addObjectButton)
    }
    
    /// Determines if the tap gesture for presenting the `AudioNodeSelectionViewController` should be used.
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return audioNodeLoader.loadedNodes.isEmpty
    }
    
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /// - Tag: restartExperience
    func restartExperience() {
        guard isRestartAvailable, !audioNodeLoader.isLoading else { return }
        isRestartAvailable = false

        statusViewController.cancelAllScheduledMessages()

        audioNodeLoader.removeAllAudioNodes()
        addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
        addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])

        resetTracking()

        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
            self.upperControlsView.isHidden = false
        }
    }
}

extension AudioDesignerViewController: UIPopoverPresentationControllerDelegate {
    
    // MARK: - UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // All menus should be popovers (even on iPhone).
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        guard let identifier = segue.identifier,
              let segueIdentifer = SegueIdentifier(rawValue: identifier),
              segueIdentifer == .showObjects else { return }
        
        let nodeSelectionViewController = segue.destination as! AudioNodeSelectionViewController
        nodeSelectionViewController.audioNodes = AudioNode.availableSounds
        nodeSelectionViewController.delegate = self
        nodeSelectionViewController.sceneView = sceneView
        self.nodeSelectionViewController = nodeSelectionViewController
        
        // Set all rows of currently placed nodes to selected.
        for node in audioNodeLoader.loadedNodes {
            guard let index = AudioNode.availableSounds.firstIndex(of: node) else { continue }
            nodeSelectionViewController.selectedAudioNodeRows.insert(index)
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        nodeSelectionViewController = nil
    }
}
