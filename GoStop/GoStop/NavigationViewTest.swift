//
//  NavigationViewTest.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/18.
//

import SwiftUI

struct NavigationViewTest: View {
    var body: some View {
        Text("Hello")
    }
}

struct TextView: View {
    var body: some View {
        NavigationView {
            Text("here")
        }
    }
}
struct NavigationViewTest_Previews: PreviewProvider {
    static var previews: some View {
        NavigationViewTest()
    }
}
