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
    
    var body: some View {
        VStack {
            // Group Top
            Group {
                HStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                    .foregroundStyle(.tint)
                    Text("\(visibleRegion?.center.latitude ?? 0.0) \(visibleRegion?.center.longitude ?? 0.0)")
                }
            }
            
            // Group Map
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
           
            // Group Bottom
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
                    .buttonStyle(.borderedProminent)
                    Spacer()
                    LocationButton(.currentLocation) {
                        locationManager.requestLocation()
                    }
                    .font(.callout)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
