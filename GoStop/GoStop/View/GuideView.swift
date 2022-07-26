//
//  NavigationViewTest.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/18.
//

import SwiftUI

struct GuideView: View {

    @State var guideImages = [Image("그룹 92"),Image("그룹 93"),Image("그룹 94"),Image("그룹 95"),Image("그룹 96"),Image("그룹 97")]
    @State var currentPage = 0
    @Binding var isNavigationViewReady: Bool
    @Binding var readyForStart: Bool
    
    @State var animation = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        if currentPage > 0 {
                                currentPage -= 1
                        }
                    } label: {
                        if currentPage > 0 {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                        } else {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    Text("가이드")
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        withAnimation {
                            isNavigationViewReady.toggle()
                        }
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                .font(.system(size: 18))
                ZStack {
                    Color.red
                        .ignoresSafeArea(.all, edges: .bottom)
                    guideImages[currentPage]
                        .resizable()
                        .aspectRatio(3/7, contentMode: .fit)
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                            .onEnded({ value in
                                                if value.translation.width < 0 {
                                                    //left
                                                    if currentPage < 5 {
                                                        currentPage += 1
                                                    }
                                                    
                                                }

                                                if value.translation.width > 0 {
                                                    //right
                                                    if currentPage > 0 {
                                                        currentPage -= 1
                                                    }
                                                }
                        }))
                        .offset(y: 50)
                        .animation(.easeOut, value: currentPage)
                    VStack {
                        pageControl(current: currentPage)
                            .padding(.top)
                        Spacer()
                        ZStack() {
                            RoundedRectangle(cornerRadius: 26).fill().foregroundColor(.black)
                            Button {
                                if currentPage  < 5 {
                                    currentPage += 1
                                } else {
                                    withAnimation {
                                        readyForStart.toggle()
                                        isNavigationViewReady.toggle()
                                    }
                                }
                                
                            } label: {
                                Text(currentPage < 5 ? "다음" : "시작하기")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.system(size: 16))
                                    .frame(width: 318, height: 52)
                            }
                        }.frame(width: 318, height: 52)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct pageControl: UIViewRepresentable {
    
    var current: Int
    
    func makeUIView(context: UIViewRepresentableContext<pageControl>) -> pageControl.UIViewType {
        let page = UIPageControl()
        page.currentPageIndicatorTintColor = .white
        page.numberOfPages = 6
        page.pageIndicatorTintColor = .lightGray
        return page
    }
    
    func updateUIView(_ uiView: UIPageControl, context: UIViewRepresentableContext<pageControl>) {
        
        uiView.currentPage = current
    }
}

struct NavigationViewTest_Previews: PreviewProvider {
    static var previews: some View {
        GuideView(isNavigationViewReady: .constant(false), readyForStart: .constant(false))
    }
}
