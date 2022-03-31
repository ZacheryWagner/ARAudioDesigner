//
//  AudioSelectionTableViewController.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/30/22.
//

import Foundation
import UIKit
import ARKit

// MARK: - AudioNodeSelectionViewControllerDelegate

/// A protocol for reporting which nodes  have been selected.
protocol AudioNodeSelectionViewControllerDelegate: AnyObject {
    func audioNodeSelectionViewController(_ selectionViewController: AudioNodeSelectionViewController, didSelectObject: AudioNode)
    func audioNodeSelectionViewController(_ selectionViewController: AudioNodeSelectionViewController, didDeselectObject: AudioNode)
}

/// A custom table view controller to allow users to select `AudioNode`s for placement in the scene.
class AudioNodeSelectionViewController: UITableViewController {
    
    /// The collection of `AudioNode`s to select from.
    var audioNodes = [AudioNode]()
    
    /// The rows of the currently selected `AudioNode`s.
    var selectedAudioNodeRows = IndexSet()
    
    /// The rows of the 'AudioNode's that are currently allowed to be placed.
    var enabledAudioNodeRows = Set<Int>()
    
    weak var delegate: AudioNodeSelectionViewControllerDelegate?
    
    weak var sceneView: ARSCNView?

    private var lastObjectAvailabilityUpdateTimestamp: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }
    
    func updateObjectAvailability() {
        guard let sceneView = sceneView else { return }
        
        // Update node availability only if the last update was at least half a second ago.
        if let lastUpdateTimestamp = lastObjectAvailabilityUpdateTimestamp,
            let timestamp = sceneView.session.currentFrame?.timestamp,
            timestamp - lastUpdateTimestamp < 0.5 {
            return
        } else {
            lastObjectAvailabilityUpdateTimestamp = sceneView.session.currentFrame?.timestamp
        }
                
        var newEnabledAudioNodeRows = Set<Int>()
        for (row, node) in AudioNode.availableSounds.enumerated() {
            // Enable row always if item is already placed, in order to allow the user to remove it.
            if selectedAudioNodeRows.contains(row) {
                newEnabledAudioNodeRows.insert(row)
            }
            
            // Enable row if item can be placed at the current location
            if let query = sceneView.getRaycastQuery(for: .any),
                let result = sceneView.castRay(for: query).first {
                node.mostRecentInitialPlacementResult = result
                node.raycastQuery = query
                newEnabledAudioNodeRows.insert(row)
            } else {
                node.mostRecentInitialPlacementResult = nil
                node.raycastQuery = nil
            }
        }
        
        // Only reload changed rows
        let changedRows = newEnabledAudioNodeRows.symmetricDifference(enabledAudioNodeRows)
        enabledAudioNodeRows = newEnabledAudioNodeRows
        let indexPaths = changedRows.map { row in IndexPath(row: row, section: 0) }

        DispatchQueue.main.async {
            self.tableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellIsEnabled = enabledAudioNodeRows.contains(indexPath.row)
        guard cellIsEnabled else { return }
        
        let node = audioNodes[indexPath.row]
        
        // Check if the current row is already selected, then deselect it.
        if selectedAudioNodeRows.contains(indexPath.row) {
            delegate?.audioNodeSelectionViewController(self, didDeselectObject: node)
        } else {
            delegate?.audioNodeSelectionViewController(self, didSelectObject: node)
        }

        dismiss(animated: true, completion: nil)
    }
        
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioNodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AudioTableViewCell.reuseIdentifier,
            for: indexPath) as? AudioSelectionTableViewCell else {
            fatalError("Expected AudioSelectionTableViewCell type")
        }
        
        cell.soundName = audioNodes[indexPath.row].soundName

        if selectedAudioNodeRows.contains(indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        let cellIsEnabled = enabledAudioNodeRows.contains(indexPath.row)
        if cellIsEnabled {
            cell.vibrancyView.alpha = 1.0
        } else {
            cell.vibrancyView.alpha = 0.1
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cellIsEnabled = enabledAudioNodeRows.contains(indexPath.row)
        guard cellIsEnabled else { return }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cellIsEnabled = enabledAudioNodeRows.contains(indexPath.row)
        guard cellIsEnabled else { return }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear
    }
}
