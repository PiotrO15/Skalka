//
//  MapView.swift
//  skalka
//
//  Created by stud on 05/11/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var selectedMarker: UUID?
    @State private var text: String = ""
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    
    var filteredLocations: [any Location] {
            if text.isEmpty {
                return []
            } else {
                return locations
                    .filter { $0.name.folding(options: .diacriticInsensitive, locale: nil).lowercased().contains(text.lowercased()) }
                    .prefix(3)
                    .map { $0 }
            }
        }
    
    var body: some View {
        ZStack {
            VStack {
                Map(position: $cameraPosition,
                    selection: $selectedMarker
                ) {
                    ForEach(locations, id: \.id) { location in
                        Annotation(location.name, coordinate: location.locationCoordinate) {
                            Image(systemName: location.systemImage)
                                .onTapGesture(count: 2) {
                                    selectedMarker = location.id
                                    
                                    setCamera(coordinate: location.locationCoordinate)
                                }
                        }
                    }
                }
                
                if let marker = selectedMarker {
                    VStack {
                        let location = locations.first(where: {$0.id == marker})!
                        Spacer()
                        withAnimation(.easeIn(duration: 3.5)) {
                            MarkerDetailView(marker: location)
                        }
                    }
                }
            }
         
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("Szukaj na mapie", text: $text, onCommit: {
                        searchLocation(query: text)
                    })
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(.white)
                .cornerRadius(20)
                
                if !filteredLocations.isEmpty {
                    VStack(alignment: .leading) {
                        ForEach(filteredLocations, id: \.id) { location in
                            Button(action: {
                                // When a suggestion is selected, set the camera and update selected marker
                                setCamera(coordinate: location.locationCoordinate)
                                selectedMarker = location.id
                                text = location.name // Optionally update search field with selected name
                            }) {
                                HStack {
                                    Text(location.name)
                                        .padding(.vertical, 5)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .background(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                }
                Spacer()
            }
            .padding()

        }
    }
    
    func searchLocation(query: String) {
            // Find the location based on the search query
            if let location = locations.first(where: { $0.name.lowercased().contains(query.lowercased()) }) {
                // Update the camera to focus on the found location
                setCamera(coordinate: location.locationCoordinate)
                // Optionally select the marker
                selectedMarker = location.id
            } else {
                // Optionally handle the case when no match is found
                print("No location found matching: \(query)")
            }
        }
    
    func setCamera(coordinate: CLLocationCoordinate2D) {
        cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
            center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
}

struct MarkerDetailView: View {
    var marker: any Location
    @State private var starred: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HStack {
                    Text(marker.name)
                        .font(.title2)
                    Spacer()
                    Button(action: {
                        starred.toggle()
                        user.starred.append(marker.id)
                    }, label: {
                        Image(systemName: starred ? "star.fill" : "star")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(starred ? .yellow : .gray)
                            .frame(width: 28, height: 28)
                            .padding(8)
                    })
                }
                if let peakMarker = marker as? PeakLocation {
                    Text("\(Int(peakMarker.altitude)) m n.p.m.")
                }
                if let imageUrlString = marker.image, let url = URL(string: imageUrlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: .infinity)
                                .cornerRadius(20)
                        default:
                            MissingImageView()
                        }
                    }
                } else {
                    MissingImageView()
                }
                
                if let desc = marker.description {
                    Text(desc)
                }
                
                Spacer()
            }
            .padding()
            .transition(.move(edge: .bottom))
        }
        .onAppear() {
            updateStarredState()
        }
    }
    
    private func updateStarredState() {
        starred = user.starred.contains(marker.id)
    }
}

struct MissingImageView: View {
    var body: some View {
        VStack {
            Image(systemName: "photo.on.rectangle.angled")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.gray.opacity(0.6))
                .frame(width: 80)
        }
        .scaledToFit()
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(.gray.opacity(0.2))
        .cornerRadius(20)
    }
}

#Preview {
    MapView()
}
