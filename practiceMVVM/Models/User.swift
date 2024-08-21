//
//  User.swift
//  practiceMVVM
//
//  Created by Gulshan Khandale  on 21/08/24.
//

import Foundation

// MARK: - UserResponse
struct User: Codable {
    let results: [UserData]
}

// MARK: - User
struct UserData: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email:String
    let picture: Picture
}

// MARK: - Name
struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

// MARK: - Location
struct Location: Codable {
    let city: String
    let state: String
    let country: String
    let coordinates: Coordinates
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude: String
    let longitude: String
}

// MARK: - Picture
struct Picture: Codable {
    let large: String
}
