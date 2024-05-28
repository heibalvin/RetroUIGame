//
//  ImageDetailView.swift
//  RetroUIGame
//
//  Created by Alvin Heib on 25/05/2024.
//

import SwiftUI

struct ImageDetailView: View {
    let imagenamed: String
        
    var body: some View {
        Image(imagenamed)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 192)
    }
}

#Preview {
    ImageDetailView(imagenamed: "best-arcade-games-1-618be09a69c16_120")
}
