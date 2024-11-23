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
                    AsyncImage(url: URL(string: product.image)){ result in
                        result.image?
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 150, height: 200)
                    .padding(30)
                    
                    Text(product.title)
                        .font(.title)
                        .bold()
                        .padding()
                        .foregroundStyle(Color.blue)
                    
                    Text(product.description)
                        .padding()
                        .foregroundStyle(Color.secondary)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(Constants().productID)
                                .foregroundStyle(Color.secondary)

                            Text("\(product.id)")
                                .font(.title)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing){
                            Text(Constants().price)
                                .foregroundStyle(Color.secondary)

                            Text("\(product.price, specifier: "%.2f") €")
                                .font(.title)
                        }
                    }
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
        .navigationTitle(viewModel.product?.category ?? Constants().productDetail)
    }
}

#Preview {
    ProductDetailView(productId: 1)
}
