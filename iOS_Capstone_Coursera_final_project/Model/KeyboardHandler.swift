//
//  KeyboardHandler.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 18/04/23.
//
import Combine
import Foundation
import UIKit

final class KeyboardHandler: ObservableObject {
    
    @Published private(set) var keyboardHeight: CGFloat = 0
    
    private var cancellable: AnyCancellable?
    
    private let keyboardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap{($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0 + 200}
    
    private let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardDidHideNotification)
        .compactMap{_ in CGFloat.zero}
    
    init() {
        cancellable = Publishers.Merge(keyboardWillHide, keyboardWillHide)
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.self.keyboardHeight, on: self)
    }
    
}
