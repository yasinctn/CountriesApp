//
//  Province.swift
//  CountriesApp
//
//  Created by Yasin Cetin on 10.05.2025.
//

import Foundation

// Province.swift
struct ProvinceResponse: Decodable {
    let status: String
    let data: [Province]
}

struct Province: Decodable {
    let id: Int
    let name: String
    let population: Int
    let area: Int
    let altitude: Int
    let areaCode: [Int]
    let isCoastal: Bool
    let isMetropolitan: Bool
    let region: Region
    let districts: [District]
}

struct Region: Decodable {
    let en: String
    let tr: String
}

struct District: Decodable {
    let id: Int
    let name: String
    let population: Int
    let area: Int
}

