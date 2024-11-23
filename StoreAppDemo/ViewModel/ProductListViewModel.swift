//
//  ProductListViewModel.swift
//  StoreAppDemo
//
//  Created by Patrik Cesnek on 23/11/2024.
//

import Foundation
import Alamofire

@MainActor
class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [String] = []
    @Published var selectedCategory: String? = nil
    @Published var isLoading = false

    func fetchProducts() async {
        isLoading = true
        let url = "https://fakestoreapi.com/products"
        do {
            let response = try await AF.request(url).serializingDecodable([Product].self).value
            self.products = response
        } catch {
            print("Error fetching products: \(error)")
        }
        isLoading = false
    }

    func fetchCategories() async {
        let url = "https://fakestoreapi.com/products/categories"
        do {
            let response = try await AF.request(url).serializingDecodable([String].self).value
            self.categories = ["Zrušiť filter"] + response
        } catch {
            print("Error fetching categories: \(error)")
        }
    }

    func filterByCategory(_ category: String?) async {
        guard let category = category, category != "Zrušiť filter" else {
            selectedCategory = nil
            await fetchProducts()
            return
        }
        isLoading = true
        let url = "https://fakestoreapi.com/products/category/\(category)"
        do {
            let response = try await AF.request(url).serializingDecodable([Product].self).value
            self.products = response
            selectedCategory = category
        } catch {
            print("Error filtering products: \(error)")
        }
        isLoading = false
    }
}
