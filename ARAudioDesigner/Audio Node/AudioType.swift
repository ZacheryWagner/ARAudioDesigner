//
//  AudioType.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/30/22.
//

import Foundation

enum AudioType {
    case waves
    case rain
    case safari
    case traffic
    case music
    
    func getAudioFileName() -> String {
        switch self {
        case .waves:
            return ""
        case .rain:
            return ""
        case .safari:
            return ""
        case .traffic:
            return ""
        case .music:
            return ""
        }
    }
}
