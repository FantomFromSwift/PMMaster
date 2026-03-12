import SwiftUI
import StoreKit

struct PaywallView_PM: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(IAPManagerVE.self) private var iapManager
    @Environment(MainViewModel.self) private var viewModel
    @State private var selectedProduct: SKProduct?
    @State private var purchaseInProgress = false
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: "Golden Tactics")
            
            VStack {
                CustomHeader_PM(title: "PREMIUM", showBackButton: true) {
                    dismiss()
                }
                
                ScrollView {
                    VStack(spacing: adaptyH(30)) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Colors_PM.gold)
                            .shadow(color: Colors_PM.gold.opacity(0.5), radius: 20)
                            .padding(.top, adaptyH(40))
                        
                        Text("UNLOCK ALL THEMES")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .tracking(2)
                        
                        Text("Get complete access to all laboratory environments and premium analytical tools.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, adaptyW(40))
                        
                        VStack(spacing: adaptyH(16)) {
                            ForEach(iapManager.products, id: \.productIdentifier) { product in
                                PremiumThemeCard(
                                    product: product,
                                    isSelected: selectedProduct?.productIdentifier == product.productIdentifier,
                                    onSelect: {
                                        if !iapManager.isPurchased(product.productIdentifier) {
                                            selectedProduct = product
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, adaptyW(20))
                        
                        Spacer().frame(height: adaptyH(20))
                        
                        VStack(spacing: 10){
                            Button(action: {
                                let productToBuy = selectedProduct ?? iapManager.products.first
                                if let p = productToBuy {
                                    purchaseInProgress = true
                                    iapManager.purchase(p)
                                }
                            }) {
                                Text("BUY NOW")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, adaptyH(18))
                                    .background(Colors_PM.gold)
                                    .clipShape(Capsule())
                            }
                            .padding(.horizontal, adaptyW(30))
                            
                            Button(action: { iapManager.restorePurchases() }) {
                                Text("Restore Purchases")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .underline()
                            }
                        }
                    }
                }
            }
            
            if iapManager.isLoading {
                ZStack {
                    Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .scaleEffect(2)
                        .tint(Colors_PM.gold)
                }
            }
        }
        .navigationBackWithSwipe()
        .onAppear {
            if iapManager.products.isEmpty {
                iapManager.fetchProducts()
            }
            if selectedProduct == nil, let first = iapManager.products.first {
                selectedProduct = first
            }
        }
        .onChange(of: iapManager.products.count) { _, newCount in
            if selectedProduct == nil, newCount > 0, let first = iapManager.products.first {
                selectedProduct = first
            }
        }
        .onChange(of: iapManager.isLoading) { _, isLoading in
            if purchaseInProgress, !isLoading {
                purchaseInProgress = false
                if iapManager.lastPurchasedProductId != nil {
                    dismiss()
                }
            }
        }
    }
}

struct PremiumThemeCard: View {
    let product: SKProduct
    let isSelected: Bool
    let onSelect: () -> Void
    @Environment(IAPManagerVE.self) private var iapManager
    
    private var isPurchased: Bool {
        iapManager.isPurchased(product.productIdentifier)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.05))
            
            if !isPurchased {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.black.opacity(0.3))
            }
            
            HStack {
                if isPurchased || isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(isPurchased ? Colors_PM.neonGreen : Colors_PM.gold)
                }
                
                VStack(alignment: .leading, spacing: adaptyH(8)) {
                    Text(product.localizedNameVE)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("\(product.localizedPriceVE) - One Time")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if !isPurchased {
                    HStack {
                        Image(systemName: "lock.fill")
                        Text("PRO")
                            .font(.caption)
                            .bold()
                    }
                    .foregroundColor(Colors_PM.gold)
                    .padding(adaptyH(8))
                    .background(Colors_PM.gold.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderColor, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
    }
    
    private var borderColor: Color {
        if isPurchased { return Colors_PM.neonGreen }
        if isSelected { return Colors_PM.gold }
        return Colors_PM.gold.opacity(0.5)
    }
}
