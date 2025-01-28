//
//  Data.swift
//  skalka
//
//  Created by stud on 10/12/2024.
//

import Foundation

var locations: [any Location] = loadLocations("locations.json")
var user: User = load("user.json")

func loadLocations(_ filename: String) -> [any Location] {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename).")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename): \n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        
        // Decode as an array of `LocationWrapper` first
        let wrapperLocations = try decoder.decode([LocationWrapper].self, from: data)
        
        // Map the decoded wrapper locations into the base `Location` protocol type
        return wrapperLocations.map { $0.location }
        
    } catch {
        fatalError("Couldn't parse \(filename) as [LocationWrapper]: \n\(error)")
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename).")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename): \n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self): \n\(error)")
    }
}
