//
//  ProductDetailViewModel.swift
//  StoreAppDemo
//
//  Created by Patrik Cesnek on 23/11/2024.
//

import Foundation
import Alamofire

@MainActor
class ProductDetailViewModel: ObservableObject {
    @Published var product: Product?

    func fetchProductDetail(productId: Int) async {
        let url = "https://fakestoreapi.com/products/\(productId)"
        do {
            let response = try await AF.request(url).serializingDecodable(Product.self).value
            self.product = response
        } catch {
            print("Error fetching product detail: \(error)")
        }
    }
}
