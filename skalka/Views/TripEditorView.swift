//
//  TripEditorView.swift
//  skalka
//
//  Created by stud on 17/12/2024.
//

import SwiftUI

struct TripEditorView: View {
    @Binding var trip: Trip?
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedTripType: TripType = .Walk
    @State private var routeLocations: [UUID] = []
    @State private var distance: Double = 0
    @State private var time: Double = 0
    
    @State private var navigate: Bool = false
    
    private func populateTripData() {
        if let trip = trip {
            startDate = trip.startDate
            endDate = trip.endDate
            selectedTripType = trip.type
            routeLocations = trip.locations
            recalculateTotals()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack() {
                    NavigationLink(destination: TripsView().navigationBarBackButtonHidden(true), label: {
                        Image(systemName: "arrow.left")
                            .font(.title)
                    })
                    
                    Spacer()
                    Text("Edytuj wycieczkę")
                        .font(.title)
                        .padding(.horizontal)
                    Spacer()
                    
                    Button(action: {
                        if saveTrip() {
                            navigate = true
                        }
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(.title)
                    })
                }
                .padding(.horizontal, 30)
                .navigationDestination(isPresented: $navigate) {
                    TripsView()
                        .navigationBarBackButtonHidden(true)
                }
            
            Form {
                Section(header: Text("Termin")) {
                    DatePicker("Początek", selection: $startDate, displayedComponents: .date)
                    DatePicker("Koniec", selection: $endDate, displayedComponents: .date)
                }
                
                Section(header: Text("Rodzaj")) {
                    Picker("", selection: $selectedTripType) {
                        Text("Wędrówka").tag(TripType.Walk)
                        Text("Bieganie").tag(TripType.Run)
                        Text("Rower").tag(TripType.Cycling)
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Trasa")) {
                    ForEach(routeLocations.indices, id: \.self) { index in
                        if let location = getLocationDetails(from: routeLocations[index]) {
                            HStack {
                                Text(location.name)
                                Spacer()
                                Image(systemName: "line.horizontal.3")
                            }
                        }
                    }
                    .onDelete(perform: deleteLocation)
                    
                    NavigationLink(destination: LocationSelectionView(onSelect: { selectedLocation in
                        addLocation(uuid: selectedLocation.id)
                    })) {
                        HStack {
                            Text("Dodaj kolejny punkt")
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("Podsumowanie")) {
                    HStack {
                        Section(header: Text("Dystans")) {
                            Text(String(format: "%.2f km", distance))
                        }
                        Spacer()
                        Section(header: Text("Czas")) {
                            Text(String(format: "%.2f godz", time))
                        }
                    }
                }
            }
                
            }
            .onAppear(perform: populateTripData)
        }
    }
    
    private func getLocationDetails(from uuid: UUID) -> (any Location)? {
        return locations.first(where: { $0.id == uuid })
    }
    
    private func addLocation(uuid: UUID) {
        routeLocations.append(uuid)
        recalculateTotals()
    }
    
    private func deleteLocation(at offsets: IndexSet) {
        routeLocations.remove(atOffsets: offsets)
        recalculateTotals()
    }
    
    private func recalculateTotals() {
        distance = Double(routeLocations.count * 5)
        time = Double(routeLocations.count * 2)
    }
    
    private func saveTrip() -> Bool {
        if routeLocations.count < 2 {
            return false
        }
        
        if var updated_trip = trip {
            updated_trip.startDate = startDate
            updated_trip.endDate = endDate
            updated_trip.distance = distance
            updated_trip.locations = routeLocations
            updated_trip.type = selectedTripType
            if let index = user.trips.firstIndex(where: {$0.id == updated_trip.id}) {
                user.trips[index] = updated_trip
            }
        } else {
            let new_trip = Trip(startDate: startDate, endDate: endDate, distance: distance, locations: routeLocations, type: selectedTripType)
            user.trips.append(new_trip)
        }
        return true
    }
}

struct LocationSelectionView: View {
    let onSelect: (any Location) -> Void
    
    var body: some View {
        NavigationView(content: {
            List(locations, id: \.id) {location in
            Button(action: {
                onSelect(location)
        }) {
            HStack {
            Text(location.name)
            Spacer()
            Image(systemName: location.systemImage)
        }
        }
        }
        })
        .navigationTitle("Dodaj punkt")
    }
}

#Preview {
    TripEditorView(trip: .constant(nil))
}
