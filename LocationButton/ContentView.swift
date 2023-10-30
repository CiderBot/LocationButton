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
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                // Group: Top
                Group {
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
                }
                
                // Group: Map
                Group {
                    Map(position: $position) {
                        if locationManager.currentLocation != nil {
                            Marker("", systemImage: "circle.circle.fill", coordinate: locationManager.currentLocation!.coordinate)
                                .tint(.blue)
                        }
                        if showAppleLoc {
                            Marker("", systemImage: "apple.logo", coordinate: .appleHQLoc)
                                .tint(.blue)
                        }
                        ForEach(selectedPlaces) { place in
                            Marker(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
                        }
                    }
                    .mapStyle(.standard(elevation: .realistic))
                    .onMapCameraChange { context in
                        visibleRegion = context.region
                    }
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
                }
               
                // Group: Bottom
                Group {
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { view in
                if view == "SearchView" {
                    // visibleRegion should never be nil, but just in case pass in a region
                    SearchView(searchRegion: visibleRegion ?? .appleHQReg, selectedPlaces: $selectedPlaces)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
