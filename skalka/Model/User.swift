import Foundation

class User: ObservableObject, Codable {
    @Published var name: String
    @Published var email: String
    @Published var trips: [Trip]
    @Published var stats: Stats
    @Published var starred: [UUID]

    struct Stats: Codable {
        let walkDistance: Double
        let runDistance: Double
        let cyclingDistance: Double
        let plannedTrips: Int
        let totalTrips: Int
        let visitedPlaces: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case name, email, trips, stats, starred
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.trips = try container.decode([Trip].self, forKey: .trips)
        self.stats = try container.decode(Stats.self, forKey: .stats)
        self.starred = try container.decode([UUID].self, forKey: .starred)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(trips, forKey: .trips)
        try container.encode(stats, forKey: .stats)
        try container.encode(starred, forKey: .starred)
    }

    init(name: String, email: String, trips: [Trip], stats: Stats, starred: [UUID]) {
        self.name = name
        self.email = email
        self.trips = trips
        self.stats = stats
        self.starred = starred
    }
}
