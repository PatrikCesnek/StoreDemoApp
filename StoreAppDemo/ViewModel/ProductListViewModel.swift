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
    
    private let baseUrl = "https://fakestoreapi.com/products"

    func fetchProducts() async {
        isLoading = true
        do {
            let response = try await AF.request(baseUrl).serializingDecodable([Product].self).value
            self.products = response
        } catch {
            print("Error fetching products: \(error)")
        }
        isLoading = false
    }

    func fetchCategories() async {
        let url = baseUrl + "/categories"
        do {
            let response = try await AF.request(url).serializingDecodable([String].self).value
            
            if selectedCategory != nil {
                self.categories = [Constants().dismissFilter] + response
            } else {
                self.categories = response
            }
        } catch {
            print("Error fetching categories: \(error)")
        }
    }

    func filterByCategory(_ category: String?) async {
        guard let category = category, category != Constants().dismissFilter else {
            selectedCategory = nil
            await fetchProducts()
            await fetchCategories()
            return
        }
        
        isLoading = true
        
        let url = baseUrl + "/category/\(category)"
        
        do {
            let response = try await AF.request(url).serializingDecodable([Product].self).value
            self.products = response
            selectedCategory = category
        } catch {
            print("Error filtering products: \(error)")
        }
        
        isLoading = false
        await fetchCategories()
    }
}
