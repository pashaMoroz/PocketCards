//
//  ModalOnlyNavigationRouter.swift
//  
//
//  Created by Moroz Pavlo on 2023-03-05.
//

import SwiftUI

/// Creates a navigation stack. Use this if you are planning to use only modals.
///
/// - Parameters:
///   - root: The view to display when the stack is empty.
public struct ModalOnlyNavigationStack<Root: View>: View {
    
    @StateObject private var router = Router()
    
    @ViewBuilder private var root: () -> Root
    
    /// Creates a navigation stack. Use this if you are planning to use only modals.
    ///
    /// - Parameters:
    ///   - root: The view to display when the stack is empty.
    public init(@ViewBuilder root: @escaping () -> Root) {
        self.root = root
    }
    
    public var body: some View {
        NavigationStack {
            root()
        }
        .environmentObject(router)
    }
}
