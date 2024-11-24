//
//  ProductModel.swift
//  StoreAppDemo
//
//  Created by Patrik Cesnek on 23/11/2024.
//

import Foundation

struct ProductRating: Codable {
    let rate: Double
    let count: Int
}

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: ProductRating
}
