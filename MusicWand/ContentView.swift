//
//  ContentView.swift
//  MusicWand
//
//  Created by ethancr0wn on 2020/09/01.
//  Copyright © 2020 ethancr0wn. All rights reserved.
//

import SwiftUI
import PDFKit

struct ContentView: View {
    
    @State private var selectedTab = 3
  
    var body: some View {
        
        TabView(selection: $selectedTab) {
            PianoView().tabItem {
                Image(systemName: "keyboard")
            }.tag(1)
            MusicSheetView().tabItem {
                Image(systemName: "wand.and.stars.inverse")
            }.tag(3)
            SettingView().tabItem {
                Image(systemName: "slider.horizontal.3")
            }.tag(4)
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
