//
//  LocationsView.swift
//  skalka
//
//  Created by stud on 05/11/2024.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.gray)
                    .padding(.trailing, 8)
                TextField("Szukaj tutaj", text: $searchText, onCommit: {
                    
                })
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(30)
            .padding(.horizontal)
            
//            ScrollView(.horizontal) {
//                HStack {
//                    Spacer(minLength: 20)
//                    Image(systemName: "slider.vertical.3")
//                        .padding(10)
//                        .background(Color.white)
//                        .cornerRadius(30)
//                    
//                    Text("Dystans")
//                        .padding(10)
//                        .background(Color.white)
//                        .cornerRadius(30)
//                    
//                }
//            }
        }
    }
}

struct SectionView: View {
    let title: String
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, content: {
                HStack {
                    Text(title)
                        .font(.title)
                        .padding(.horizontal)
                    Spacer()
                }
            })
            
            if TripsView().filteredTrips.isEmpty {
                Text("Nic tu nie ma :(")
                    .font(.title2)
                    .fontWeight(.light)
            } else {
                ForEach(TripsView().filteredTrips) { trip in
                    TripRow(trip: trip)
                }
                .onDelete(perform: deleteTrip)
            }
        }
    }
    
    private func deleteTrip(at offsets: IndexSet) {
        user.trips.remove(atOffsets: offsets)
    }
}

struct TripRow: View {
    @State var trip: Trip?
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationLink(
            destination: TripEditorView(trip: $trip).navigationBarBackButtonHidden()
        ) {
            HStack {
                VStack(alignment: .leading, spacing: 5, content: {
                    HStack {
                        if let location = locations.first(where: {$0.id == trip!.locations.first}) {
                            Text(location.name)
                                .padding(.top)
                                .padding(.leading)
                                .font(.title2)
                        }
                        if let finish_location = locations.last(where: {$0.id == trip!.locations.last}) {
                            Text("-")
                                .padding(.top)
                                .font(.title2)
                            
                            Text(finish_location.name)
                                .padding(.top)
                                .padding(.trailing)
                                .font(.title2)
                        }
                    }
                    Text(formattedDate())
                        .padding(.horizontal)
                        .font(.title2)
                        .fontWeight(.light)
                    HStack {
                        Text(String(format: "%.1f", trip!.distance) + " km")
                            .font(.title2)
                        Image(systemName: trip!.type.image())
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                })
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
    
    private func formattedDate() -> String {
        dateFormatter.dateStyle = .short
        if (Calendar.current.isDate(trip!.endDate, inSameDayAs: trip!.startDate)) {
            return dateFormatter.string(from: trip!.endDate)
        }
        return dateFormatter.string(from: trip!.startDate) + " - " + dateFormatter.string(from: trip!.endDate)
    }
}

struct TripsView: View {
    @State private var searchText = ""
    
    var filteredTrips: [Trip] {
        if searchText.isEmpty {
            return user.trips
        } else {
            let matchingLocations = locations
                .filter { $0.name.folding(options: .diacriticInsensitive, locale: nil).lowercased().contains(searchText.lowercased()) }
                .map { $0.id }
            return user.trips.filter { trip in
                trip.locations.contains { locationId in
                    matchingLocations.contains(locationId)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    SearchBar(searchText: $searchText)
                    SectionView(title: "Wycieczki")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Gray").ignoresSafeArea(.all))
                
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        NavigationLink(destination: TripEditorView(trip: .constant(nil)).navigationBarBackButtonHidden(true), label: {
                            
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                    .padding(16)
                                    .background(.white)
                                    .cornerRadius(40)
                                    .shadow(radius: 1)
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    TripsView()
}
