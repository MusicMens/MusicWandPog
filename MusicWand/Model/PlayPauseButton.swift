//
//  PlayPauseButton.swift
//  MusicWand
//
//  Created by ethancr0wn on 2020/09/18.
//  Copyright © 2020 ethancr0wn. All rights reserved.
//

import SwiftUI

struct PlayPauseButton: View {
    var active: Bool
    var body: some View {
        HStack {
            if active {
                Image(systemName:"stop.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.purple)
            } else {
                Image(systemName:"play.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.purple)
                
            }
        }
        
    }
}

