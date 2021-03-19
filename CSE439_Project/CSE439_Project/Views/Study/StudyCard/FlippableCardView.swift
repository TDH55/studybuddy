//
//  FlippableCardView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/18/21.
//

//flippable view adapted from https://stackoverflow.com/questions/60805244/swiftui-card-flip-with-two-views
// Swipe gesture derived from https://www.hackingwithswift.com/books/ios-swiftui/moving-views-with-draggesture-and-offset

import SwiftUI


struct FlippableCardView: View {
    
    let term: StudyTerm
    //If false show phrase
    @State var flipped: Bool = false
    @State private var animat3d: Bool = false
    
    @State private var offset = CGSize.zero
    
    var removal: (() -> Void)? = nil
    var body: some View {
        GeometryReader { geo in
            VStack{
                Spacer()
                
                ZStack() {
                    //Show front of card when not flipped
                    StudyCardBodyView(content: term.phrase ?? "", color: Color.init(.systemBackground))
                        .padding(5)
                        .frame(minWidth: geo.size.width * 0.75, maxWidth: geo.size.width * 0.9, minHeight: geo.size.height * 0.4, maxHeight: geo.size.height * 0.9, alignment: .center)
                        .opacity(flipped ? 0.0 : 1.0)
                        .shadow(radius: flipped ? 0 : 10)
                        .accessibility(label: Text("Study term phrase: \(term.phrase ?? ""), click for the definition or swipe to dismiss"))
                    //Show back of card when flipped
                    StudyCardBodyView(content: term.definition ?? "", color: Color.init(.systemBackground))
                        .padding(5)
                        .frame(minWidth: geo.size.width * 0.75, maxWidth: geo.size.width * 0.9, minHeight: geo.size.height * 0.4, maxHeight: geo.size.height * 0.9, alignment: .center)
                        .opacity(flipped ? 1.0 : 0.0)
                        .shadow(radius: flipped ? 10 : 0)
                        .accessibility(label: Text("Study term definition: \(term.definition ?? ""), click for the phrase or swipe to dismiss"))
                }
                .modifier(FlipEffect(flipped: $flipped, angle: animat3d ? 180 : 0, axis: (x: 1, y: 0)))
                .onTapGesture {
                    withAnimation(Animation.linear(duration: 0.3)) {
                        self.animat3d.toggle()
                    }
                }
                
                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            //TODO: Slow down swipe
            .rotationEffect(.degrees(Double(offset.width / 5)))
            .offset(x: offset.width * 2, y: 0)
            .opacity(2 - Double(abs(offset.width / 50)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.offset = gesture.translation
                    }
                    .onEnded { _ in
                        if abs(self.offset.width) > 50 {
                            //remove card
                            self.removal?()
                        } else {
                            self.offset = .zero
                        }
                    }
            )
        }
    }
}

//struct FlippableCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlippableCardView(term: StudyTerm())
//    }
//}
