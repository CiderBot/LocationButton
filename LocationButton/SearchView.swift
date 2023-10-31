//
//  SearchView.swift
//  LocationButton
//
//  Created by Steven Yung on 10/29/23.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var placeVM = PlaceViewModel()
    @State private var searchText = ""
    
    var searchRegion: MKCoordinateRegion
    @Binding var selectedPlaces: [Place]
    
    var body: some View {
        VStack {
            HStack {
                TextField("search", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)
                    .onSubmit {
                        // start search
                }
                Button("Cancel") {
                    searchText = ""
                    placeVM.placesList.removeAll()
                }
                .disabled(searchText.isEmpty)
            }
            List(placeVM.placesList) { place in
                HStack {
                    Image(systemName: selectedPlaces.contains(place) ? "circle.fill" : "circle")
                    VStack (alignment: .leading) {
                        Text(place.mapItem.name ?? "")
                            .font(.title3)
                        Text(place.address)
                    }
                }
                .onTapGesture {
                    if let index = selectedPlaces.firstIndex(of: place) {
                        selectedPlaces.remove(at: index)
                    } else {
                        selectedPlaces.append(place)
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        selectedPlaces.removeAll()
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "mappin.circle")
                        Text("Map Selected")
                    })
                    .disabled(selectedPlaces.count == 0)
                }
            }
            .onChange(of: searchText) {
                if searchText.isEmpty {
                    placeVM.placesList = []
                } else {
                    placeVM.search(searchText: searchText, region: searchRegion)
                }
            }
            
            Spacer()
        }
        .onAppear {
            // clear out the selected places to start
            selectedPlaces.removeAll()
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        SearchView(searchRegion: .appleHQReg, selectedPlaces: .constant([]))
    }
}
