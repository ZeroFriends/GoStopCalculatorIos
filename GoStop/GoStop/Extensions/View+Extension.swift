//
//  View+Extension.swift
//  GoStop
//
//  Created by 이태현 on 2022/07/18.
//

import Foundation
import SwiftUI
import UIKit

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(length))
            }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}

//struct TestTextfield: UIViewRepresentable {
//    @Binding var text: String
//    var keyType: UIKeyboardType
//    func makeUIView(context: Context) -> UITextField {
//        let textfield = UITextField()
//        textfield.keyboardType = keyType
//        textfield.textAlignment = NSTextAlignment.right
//        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
//        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
//        toolBar.items = [doneButton]
//        toolBar.setItems([doneButton], animated: true)
//        textfield.inputAccessoryView = toolBar
//        return textfield
//    }
//    
//    func updateUIView(_ uiView: UITextField, context: Context) {
//        uiView.text = text
//        
//    }
//}
//
//extension  UITextField{
//    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
//       self.resignFirstResponder()
//    }
//
//}
