//
//  Extentions.swift
//  TaskManagement
//
//  Created by Rendi Wijiatmoko on 21/04/22.
//

import SwiftUI

// MARK: UI Design helper function
extension View {
    func hLeading()-> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    func hTrailing()-> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    func hCenter ()-> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea 
    }
}
