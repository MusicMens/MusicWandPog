//
//  ScoreData.swift
//  MusicWand
//
//  Created by Code Chrysalis on 2020/09/04.
//  Copyright © 2020 ethancr0wn. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import RealmSwift

let realm: Realm = try! Realm()
let scoreData = realm.objects(musicTrack.self)
