//
//  AudioDesignerViewController.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/29/22.
//

import Foundation
import UIKit
import ARKit
import SceneKit

class AudioDesignerViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    // MARK: - UI Properties
    
    private var sceneView: AudioDesignerARView = AudioDesignerARView()
    
    @IBOutlet weak var addObjectButton: UIButton!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var upperControlsView: UIView!
    
    // - MARK: Class Properties
    
    private var viewModel: AudioDesignerViewModel

    // MARK: - Lifecycle
    
    init(viewModel: AudioDesignerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
