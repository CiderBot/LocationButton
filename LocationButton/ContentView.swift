//
//  ContentView.swift
//  LocationButton
//
//  Created by Steven Yung on 10/27/23.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    
    // sets map position
    @State private var position: MapCameraPosition = .automatic
    
    // keep track of current map region
    @State private var visibleRegion: MKCoordinateRegion?
    
    // sets user location button visibility status
    @State private var userLocation = Visibility.hidden
    @State private var showAppleLoc = false
    
    @State private var selectedPlaces: [Place] = []
    @State private var selectedIndex: Int?
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Map(position: $position, selection: $selectedIndex) {
                if locationManager.currentLocation != nil {
                    Marker("", systemImage: "circle.circle.fill", coordinate: locationManager.currentLocation!.coordinate)
                        .tint(.blue)
                }
                if showAppleLoc {
                    Marker("", systemImage: "apple.logo", coordinate: .appleHQLoc)
                        .tint(.blue)
                }
                ForEach(selectedPlaces) { place in
                    if let index = selectedPlaces.firstIndex(of: place) {
                        Marker(item: place.mapItem)
                            .tag(index)
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .onChange(of: selectedPlaces, {
                // recenter map based on search results
                position = .automatic
            })
            .onChange(of: locationManager.currentLocation, {
                userLocation = Visibility.visible
                withAnimation {
                    position = .region(locationManager.currentRegion)
                }
            })
            .mapControls {
                MapUserLocationButton()
                    .mapControlVisibility(userLocation)
                MapCompass()
                MapScaleView()
            }
            // top and bottom sections
            .safeAreaInset(edge: .top, content: {
                HStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                    .foregroundStyle(.tint)
                    Text("\(visibleRegion?.center.latitude ?? 0.0) \(visibleRegion?.center.longitude ?? 0.0)")
                    Spacer()
                    Button {
                        path.append("SearchView")
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .padding(10)
                .background(.white)
                .opacity(0.7)
                .cornerRadius(10)
                .padding()
            })
            .safeAreaInset(edge: .bottom, content: {
                VStack {
                    if let selectedIndex {
                        PlaceInfoView(selectedPlace: selectedPlaces[selectedIndex])
                            .frame(height: 128)
                    }
                    HStack {
                        Button(action: {
                            showAppleLoc = true
                            withAnimation {
                                position = .region(.appleHQReg)
                            }
                        }, label: {
                            Image(systemName: "apple.logo")
                            Text("Apple HQ")
                        })
                        .font(.callout)
                        .buttonStyle(.borderless)
                        Spacer()
                        LocationButton(.currentLocation) {
                            locationManager.requestLocation()
                        }
                        .font(.callout)
                        .symbolVariant(.fill)
                        .foregroundColor(.blue)
                        .tint(.white)
                    }
                }
                .padding(10)
                .background(.white)
                .cornerRadius(10)
                .padding()
            })
            // navigation stuff
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { view in
                if view == "SearchView" {
                    // visibleRegion should never be nil, but just in case pass in a region
                    SearchView(searchRegion: visibleRegion ?? .appleHQReg, selectedPlaces: $selectedPlaces)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
