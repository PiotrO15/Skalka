//
//  ContentView.swift
//  skalka
//
//  Created by stud on 05/11/2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var selection: Int
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        selection = 2
    }
    
    init(sel: Int) {
        UITabBar.appearance().backgroundColor = UIColor.white
        selection = sel
    }
    
    var body: some View {
        TabView(selection: $selection) {
            TripsView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Wycieczki")
                }
                .tag(1)
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Mapa")
                }
                .tag(2)
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profil")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
