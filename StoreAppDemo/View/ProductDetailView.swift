//
//  ProductDetailView.swift
//  StoreAppDemo
//
//  Created by Patrik Cesnek on 23/11/2024.
//

import SwiftUI

struct ProductDetailView: View {
    @StateObject private var viewModel = ProductDetailViewModel()
    let productId: Int

    var body: some View {
        VStack {
            if let product = viewModel.product {
                ScrollView {
                    AsyncImage(url: URL(string: product.image))
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding()
                    Text(product.title)
                        .font(.largeTitle)
                        .padding()
                    Text("\(product.price, specifier: "%.2f") €")
                        .font(.title2)
                        .padding(.bottom)
                    Text("\(Constants().rating) \(product.rating.rate, specifier: "%.1f") \(Constants().of) 5")
                        .font(.subheadline)
                        .padding(.bottom, 2)
                    Text("\(Constants().numberOfReviews) \(product.rating.count)")
                        .font(.subheadline)
                        .padding(.bottom, 10)
                    Text(product.description)
                        .font(.body)
                        .padding()
                }
            } else {
                ProgressView(Constants().loading)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchProductDetail(productId: productId)
            }
        }
        .navigationTitle(Constants().productDetail)
    }
}

#Preview {
    ProductDetailView(productId: 1)
}
