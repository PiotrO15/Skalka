//
//  Location.swift
//  skalka
//
//  Created by stud on 03/12/2024.
//

import Foundation
import MapKit

protocol Location: Hashable, Codable, Identifiable {
    var id: UUID { get }
    var name: String { get }
    var systemImage: String { get }
    var coordinates: Coordinates { get }
    var image: String? { get }
    var description: String? { get }
    
    var locationCoordinate: CLLocationCoordinate2D { get }
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}

extension Location {
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}

struct PeakLocation: Location {
    var id = UUID()
    let name: String
    let coordinates: Coordinates
    let altitude: Double
    let systemImage = "mountain.2.fill"
    let image: String?
    let description: String?
}

struct ShelterLocation: Location {
    var id = UUID()
    let name: String
    let coordinates: Coordinates
    let systemImage = "house.fill"
    let image: String?
    let description: String?
}

enum LocationWrapper: Codable {
    case peak(PeakLocation)
    case shelter(ShelterLocation)

    enum CodingKeys: String, CodingKey {
        case type
        case location
    }

    enum LocationType: String, Codable {
        case peak
        case shelter
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(LocationType.self, forKey: .type)

        switch type {
        case .peak:
            let location = try container.decode(PeakLocation.self, forKey: .location)
            self = .peak(location)
        case .shelter:
            let location = try container.decode(ShelterLocation.self, forKey: .location)
            self = .shelter(location)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .peak(let location):
            try container.encode(LocationType.peak, forKey: .type)
            try container.encode(location, forKey: .location)
        case .shelter(let location):
            try container.encode(LocationType.shelter, forKey: .type)
            try container.encode(location, forKey: .location)
        }
    }
}

extension LocationWrapper {
    var location: any Location {
        switch self {
        case .peak(let peakLocation):
            return peakLocation
        case .shelter(let shelterLocation):
            return shelterLocation
        }
    }
}
