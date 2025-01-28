//
//  ProfileView.swift
//  skalka
//
//  Created by stud on 26/11/2024.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.accent)
                    
                    VStack(alignment: .leading) {
                        Text(user.name)
                        Text(user.email)
                    }
                    
                    Spacer()
                }
                
                VStack(spacing: 16) {
                    Text("Pokonany dystans")
                        .font(.title)
                    
                    HStack(spacing: 40) {
                        Image(systemName: "figure.walk")
                            .font(.title2)
                        Spacer()
                        Text(String(user.stats.walkDistance) + " km")
                            .font(.title2)
                    }
                    
                    HStack(spacing: 40) {
                        Image(systemName: "figure.run")
                            .font(.title2)
                        Spacer()
                        Text(String(user.stats.runDistance) + " km")
                            .font(.title2)
                    }
                    
                    HStack(spacing: 40) {
                        Image(systemName: "bicycle")
                            .font(.title2)
                        Spacer()
                        Text(String(user.stats.cyclingDistance) + " km")
                            .font(.title2)
                    }
                }
                .padding()
                .background(.white)
                .cornerRadius(20)
                
                VStack(spacing: 16) {
                    Text("Twoje statystyki")
                        .font(.title)
                    
                    HStack(spacing: 40) {
                        Text("Zakończone wycieczki")
                            .font(.title2)
                        Spacer()
                        Text(String(user.stats.totalTrips))
                            .font(.title2)
                    }
                    
                    HStack(spacing: 40) {
                        Text("Zaplanowane wycieczki")
                            .font(.title2)
                        Spacer()
                        Text(String(user.stats.plannedTrips))
                            .font(.title2)
                    }
                    
                    HStack(spacing: 40) {
                        Text("Odkryte miejsca")
                            .font(.title2)
                        Spacer()
                        Text(String(user.stats.visitedPlaces))
                            .font(.title2)
                    }
                }
                .padding()
                .background(.white)
                .cornerRadius(20)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Gray").ignoresSafeArea(.all))
    }
}

#Preview {
    ProfileView()
}
