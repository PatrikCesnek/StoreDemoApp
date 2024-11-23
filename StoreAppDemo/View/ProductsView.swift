//
//  ProductsView.swift
//  StoreAppDemo
//
//  Created by Patrik Cesnek on 23/11/2024.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductListViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Načítavam...")
                } else {
                    List(viewModel.products) { product in
                        NavigationLink(destination: ProductDetailView(productId: product.id)) {
                            HStack {
                                AsyncImage(url: URL(string: product.image))
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                VStack(alignment: .leading) {
                                    Text(product.title)
                                        .font(.headline)
                                    Text("\(product.price, specifier: "%.2f") €")
                                        .font(.subheadline)
                                    HStack {
                                        Text("Hodnotenie: \(product.rating.rate, specifier: "%.1f")")
                                        Spacer()
                                        Text("Počet: \(product.rating.count)")
                                    }
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.selectedCategory ?? "Produkty")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Menu("Filter") {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Button(category) {
                            Task {
                                await viewModel.filterByCategory(category)
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchProducts()
                    await viewModel.fetchCategories()
                }
            }
        }
    }
}

#Preview {
    ProductsView()
}
