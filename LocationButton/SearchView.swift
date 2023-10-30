//
//  SearchView.swift
//  LocationButton
//
//  Created by Steven Yung on 10/29/23.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchString = ""
    
    var body: some View {
        VStack {
            TextField("search", text: $searchString)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
                .onSubmit {
                    // start search
                }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
