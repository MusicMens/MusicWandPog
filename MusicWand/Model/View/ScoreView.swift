//
//  ScoreView.swift
//  MusicWand
//
//  Created by ethancr0wn on 2020/09/08.
//  Copyright © 2020 ethancr0wn. All rights reserved.
//

import SwiftUI
import RealmSwift

struct ScoreView: View {
    var trackData : musicTrack
    @State private var colsRowsData =  Note(col:0, row:0 , imgName: "MusicNote")
    @State private var movingNoteLocation = CGPoint(x: 200, y: 200)
    @State private var fromPoint: CGPoint?
    @State private var movingNote: Note?
    @State var notes = MusicTracks.allNotes
    @State var tempo = ""
    @State var enteredNumber = ""
    @ObservedObject var scoreModel:ScoreModel
    var sequencer = Conductor.shared
    var body: some View {
        
        
        VStack {
            VStack(spacing: 10) {
                
                HStack {
                    VStack {
                        TextField("\(self.enteredNumber)", text: $tempo)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 65, height: 30)
                        Button("submit") {
                            self.enteredNumber = self.tempo
                            self.tempo = ""
                             self.hideKeyboard()
                            }.padding(3)
                            
                        .foregroundColor(.white)
                            .background(Color.blue)
                        .cornerRadius(5)
                    }.padding()
                        
                    Button(action: {
                        
                    }) {
                        Image(systemName:"arrow.left.square.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    Button(action: {}) {
                        Image(systemName: "arrow.right.square.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }.padding()
                    Button(action: {}) {
                        Image(systemName:"arrow.up.square.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }.padding()
                    Button(action: {}) {
                        Image(systemName: "arrow.down.square.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                }.padding(Edge.Set(rawValue: 100),140)
            }
            
            HStack {
                VStack {
                    GeometryReader { fullView in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                GeometryReader { geo in
                                    ScoreGrid( bounds: geo.frame(in: .local), cols: 23)
                                        .stroke()
                                    ForEach(Array(self.scoreModel.notes), id: \.id) { note in
                                        Image(note.imgName)
                                            .resizable()
                                            //                            .frame(width: cellWidth(bounds: geo.frame(in: .local)), height: cellHeight(bounds: geo.frame(in: .local)))
                                            .frame(width: 30, height: 30)
                                            .position(notePosition(bounds: geo.frame(in: .local), col: note.col, row: note.row))
                                            .gesture(DragGesture().onChanged({ value in
                                                self.movingNoteLocation = value.location
                                                if self.fromPoint == nil {
                                                    self.fromPoint = value.location
                                                    let (fromCol, fromRow) = xyToColRow(bounds: geo.frame(in: .local), x: value.location.x, y: value.location.y)
                                                    self.movingNote = self.scoreModel.noteAt(col: fromCol, row: fromRow)
                                                }
                                            }).onEnded({ value in
                                                let toPoint: CGPoint = value.location
                                                if let fromPoint = self.fromPoint {
                                                    let (fromCol, fromRow) = xyToColRow(bounds: geo.frame(in: .local), x: fromPoint.x, y: fromPoint.y)
                                                    let (toCol, toRow) = xyToColRow(bounds: geo.frame(in: .local), x: toPoint.x, y: toPoint.y)
                                                    self.colsRowsData.col = toCol
                                                    self.colsRowsData.row = toRow
                                                    
                                                    
                                                    
                                                    print("from col:(\(fromCol), from row: \(fromRow) to col:\(toCol), to row: \(toRow)")
                                                    self.moveNote(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
                                                }
                                                
                                                self.fromPoint = nil
                                                self.movingNote = nil
                                            }))
                                        
                                    }
                                    if self.movingNote != nil {
                                        Image(self.movingNote!.imgName)
                                            .resizable()
                                            //                           .frame(width: cellWidth(bounds: geo.frame(in: .local)), height: cellHeight(bounds: geo.frame(in: .local)))
                                            .frame(width: 30, height: 30)
                                            .position(self.movingNoteLocation)
                                    }
                                    
                                    
                                }
                                .frame(width: 410, height: 350)
                                ForEach(0..<55)  { index in
                                    Text("-")
                                        .foregroundColor(Color.white)
                                    Text("-")
                                        .foregroundColor(Color.white)
                                    
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
            
            
            HStack(spacing: 65) {
                Button(action: {
                    //self.scoreModel.addNewNote()
                }) {
                    Text("New note")
                        .font(.headline)
                    
                    
                }.padding(6)
                .foregroundColor(.white)
                    .background(Color.blue)
                .cornerRadius(5)
                Button(action: {
                    //self.scoreModel.clearAllNote()
                }) {
                    Text("Clear all")
                        .font(.headline)
                    
                }.padding(6)
                .foregroundColor(.white)
                                   .background(Color.blue)
                               .cornerRadius(5)
            }
            
            
            VStack {
                HStack {
                    
                    Button(action: {}) {
                        Image(systemName:"backward.end.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }.padding(25)
                    Button(action: {self.sequencer.play()}) {
                        Image(systemName: "playpause.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }.padding(50)
                    Button(action: {}) {
                        Image(systemName:"repeat")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }.padding()
                    
                }
            }
            Spacer()
            
        }.navigationBarTitle(self.trackData.title)
        
        
        
        
    }
    
 
           func hideKeyboard() {
               UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
           }
   
   
    
    func moveNote(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        scoreModel.moveNote(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
    }
    
    func createNote() {
        
    }
    
}

func xyToColRow(bounds: CGRect, x: CGFloat, y: CGFloat) -> (Int, Int) {
    let col: Int = Int((x - originX(bounds: bounds)) / cellWidth(bounds: bounds))
    let row: Int = Int((y - originY(bounds: bounds)) / cellHeight(bounds: bounds))
    return (col, row)
}


func originX(bounds: CGRect) -> CGFloat {
    return bounds.size.width * 0.1
}

func originY(bounds: CGRect) -> CGFloat {
    return bounds.size.height * 0.1
}

func cellWidth(bounds: CGRect) -> CGFloat {
    
    return bounds.size.width * 0.15
}
func cellHeight(bounds: CGRect) -> CGFloat {
    let rows: Int = 19
    return  (bounds.size.height * 0.3) / CGFloat(rows)
}


func notePosition(bounds: CGRect, col: Int, row: Int) -> CGPoint {
    let x = originX(bounds: bounds) + CGFloat(col) * cellWidth(bounds: bounds)
    let y = originY(bounds: bounds) + CGFloat(row) * cellHeight(bounds: bounds) - 15
    return CGPoint(x: x, y: y)
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif



//struct ScoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoreView(scoreModel: ScoreModel())
//    }
//}

