//
//  CardView.swift
//  PocketCards
//
//  Created by Moroz Pavlo on 2023-09-12.
//

import SwiftUI

struct CardView: View {
    var card: CardModel
    @State var offset = CGSize.zero
    @State var color = Color.white
    @State var isTeached: Bool = false
    @State var textStatusOpacity = 0.0
    @State var isTextStatusVisible: Bool = false
    
    var body: some View {
        VStack {
            Text(isTeached ? "I know": "Need to repeat")
                .font(.largeTitle)
                .foregroundColor(isTeached ? Color.green.opacity(textStatusOpacity) : Color.red.opacity(textStatusOpacity) )
                .bold()
                .opacity(isTextStatusVisible ? 1.0 : 0)
            ZStack {
                Rectangle()
                    .frame(width: 320, height: 420)
                    .border(.white, width: 2)
                    .cornerRadius(15)
                    .foregroundColor(color)
                    .shadow(radius: 1.5)
                HStack {
                    Text(card.name)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .bold()
                }
            }
            .offset(x: offset.width, y: offset.height * 0.1)
            .rotationEffect(.degrees(Double(offset.width / 40)))
            .gesture(DragGesture()
                .onChanged({ gesture in
                    offset = gesture.translation
                    isTextStatusVisible = true
                    withAnimation {
                        changeColor(with: offset.width)
                    }
                })
                    .onEnded({ _ in
                        isTextStatusVisible = true
                        withAnimation {
                            swipeCard(width: offset.width)
                            changeColor(with: offset.width)
                        }
                    })
            )
        }
    }
    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            print("Card removed")
            isTextStatusVisible = false
            offset = CGSize(width: -500, height: 0)
            
        case 150...500:
            print("Card added")
            isTextStatusVisible = false
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
    
    func changeColor(with: CGFloat) {
        switch with {
        case -500...(-20):
            color = .red
            textStatusOpacity = changeOpacity(width: with)
            isTeached = false
        case 20...500:
            color = .green
            textStatusOpacity = changeOpacity(width: with)
            isTeached = true
        default : color = .white
            textStatusOpacity = 0.0
            isTeached = false
        }
    }
    
    private func changeOpacity(width: CGFloat) -> Double {
        
        var opacity = 1.0
        
        switch width {
        case -50...50:
            opacity = 0.2
        case -100...100:
            opacity = 0.4
        case -150...150:
            opacity = 0.6
        case -200...200:
            opacity = 0.8
        case -500...500:
            opacity = 1.0
        default:
            opacity = 0.0
        }
        
        return opacity
    }
}
