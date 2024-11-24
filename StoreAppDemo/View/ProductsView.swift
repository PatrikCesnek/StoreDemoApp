//
//  ProductsView.swift
//  StoreAppDemo
//
//  Created by Patrik Cesnek on 23/11/2024.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductListViewModel()
    @State private var showFilterDialog = false

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView(Constants().loading)
                } else {
                    List(viewModel.products) { product in
                        NavigationLink(
                            destination: ProductDetailView(productId: product.id)
                        ) {
                            HStack {
                                AsyncImage(url: URL(string: product.image)){ result in
                                    result.image?
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: 50, height: 50)
                                .padding()
                                
                                VStack(alignment: .leading) {
                                    Text(product.title)
                                        .font(.headline)
                                    
                                    Text(product.category)
                                        .font(.footnote)
                                        .foregroundStyle(Color.secondary)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle(viewModel.selectedCategory ?? Constants().products)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(
                    action: {
                        showFilterDialog = true
                    }
                ) {
                    Text(Constants().filter)
                }
            }
            .confirmationDialog(
                Constants().filter,
                isPresented: $showFilterDialog,
                titleVisibility: .hidden
            ) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button(category) {
                        Task {
                            await viewModel.filterByCategory(category)
                        }
                    }
                }
                Button(Constants().close, role: .cancel) { }
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
