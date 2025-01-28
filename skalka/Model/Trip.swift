//
//  Trip.swift
//  skalka
//
//  Created by stud on 10/12/2024.
//

import Foundation

enum TripType: Codable {
    case Walk
    case Run
    case Cycling
    
    func image() -> String {
        switch self {
        case .Walk:
            return "figure.walk"
        case .Run:
            return "figure.run"
        case .Cycling:
            return "bicycle"
        }
    }
}

struct Trip: Identifiable, Codable {
    var id: UUID = UUID()
    var startDate: Date
    var endDate: Date
    var distance: Double
    var locations: [UUID]
    var type: TripType
}
