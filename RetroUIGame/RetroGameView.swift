//
//  ImageDetailView.swift
//  RetroUIGame
//
//  Created by Alvin Heib on 25/05/2024.
//

import SwiftUI
import SpriteKit

struct RetroGameView: View {
    var id: Int
    
    var scene: SKScene {
        let scene = RetroGameScene(id: id)
        scene.size = CGSize(width: 320, height: 224)
        scene.scaleMode = .aspectFit
        scene.anchorPoint = .zero
        return scene
    }
        
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview {
    RetroGameView(id: 9)
}
