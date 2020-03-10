//
//  VideoInput.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/2/28.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import CoreMedia

protocol VideoInput: class {
    
    var nextAvailableTextureIndex: Int { get }
    var enabled: Bool  { get }
    
    func setInputFrameBuffer(_ inputFrameBuffer: FrameBuffer?, at index: Int)
    func setInputRotation(_ rotation: VideoRotation, at index: Int)
    func setInputSize(_ size: CGSize, at index: Int)
    func newFrameReady(at time: CMTime, at index: Int)
    func endProcessing()

}
