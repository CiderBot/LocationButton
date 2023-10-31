//
//  PlaceInfoView.swift
//  LocationButton
//
//  Created by Steven Yung on 10/31/23.
//

import SwiftUI
import MapKit

struct PlaceInfoView: View {
    var selectedPlace: Place!
    
    @State private var lookAroundScene: MKLookAroundScene?
    
    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Text("\(selectedPlace.mapItem.name ?? "")")
                    Text("\(selectedPlace.address)")
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(10)
            }
            .onAppear {
                getLookAroundScene()
            }
            .onChange(of: selectedPlace) {
                getLookAroundScene()
            }
    }
    
    func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: selectedPlace.mapItem)
            lookAroundScene = try? await request.scene
        }
    }
}
/*
#Preview {
    PlaceInfoView()
}
*/
