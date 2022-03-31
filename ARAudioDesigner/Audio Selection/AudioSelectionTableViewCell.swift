//
//  AudioSelectionTableViewCell.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/30/22.
//

import Foundation

class AudioTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AudioSelectionTableViewCell"
    
    @IBOutlet weak var nodeTitleLabel: UILabel!
    @IBOutlet weak var nodeImageView: UIImageView!
    @IBOutlet weak var vibrancyView: UIVisualEffectView!
    
    var soundName = "" {
        didSet {
            nodeTitleLabel.text = soundName.capitalized
            nodeImageView.image = UIImage(named: soundName)
        }
    }
}
