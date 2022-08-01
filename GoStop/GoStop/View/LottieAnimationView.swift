//
//  ContentView.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/12.
//
import SwiftUI
import Lottie
import UIKit

struct LottieView: UIViewRepresentable {
    
    var filename: String
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        
        let view = UIView(frame: .zero)
        let animationView = AnimationView()

        animationView.animation = Animation.named(filename)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
}

struct LottieAnimationView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    LottieView(filename: "로티이미지")
                        .frame(width: 96, height: 111)
                        .position(x: geometry.size.width/2, y: geometry.size.height/2)
                    Image("main")
                        .background(Color.white)
                        .position(x: geometry.size.width/2, y: geometry.size.height/2 + 27)
                }

                Text("ZEROFRIENDS")
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LottieAnimationView()
    }
}
