# IAPPaywall

A powerful, easy-to-use SwiftUI library for implementing in-app purchase paywalls in iOS applications. Built with the latest StoreKit 2 APIs and designed to maximize conversion rates while providing a seamless user experience.

## Features

- 🎨 **Fully Customizable**
- 🛒 **StoreKit 2 Integration**
- 🎯 **Smart Configuration** - Flexible plan configurations and trial management

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Installation

### Swift Package Manager

Add IAPPaywall to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/leocallas/IAPPaywall.git", from: "2.0.4")
]
```

## Quick Start

### 1. Configure Your App

Add the StoreKit configuration file to your app bundle and configure your products in App Store Connect.

### 2. One-Line Setup

Simply configure the library in your app:

```swift
import IAPPaywall

InAppPurchase.configure()
```

### 2. Check Subscription Status

```swift
InAppPurchase.shared.hasPurchased
```
### 3. Testing Mode (Disable IAP)

For testing or demo purposes, you can disable in-app purchases and always return `InAppPurchase.shared.hasPurchased = true`:

```swift
#if DEBUG
  // Disable IAP for testing purposes
  InAppPurchase.shared.setDisabled()
#endif
```
## Usage Examples

### Basic Paywall

```swift
let model = IAPPaywallModel(
    plans: [
        .init(id: "monthly_plan_id", type: .monthly),
        .init(id: "yearly_plan_id", type: .yearly)
    ]
)

IAPPaywallView(model: model)
    .onPurchase { result, plan in
        switch result {
        case .success:
            // Handle success
        case .userCancelled:
            // Handle cancellation
        }
    }
    .onRestore { restored in
        if restored {
            // Purchases restored successfully
        }
    }
```

## Customization

### Custom Plans

```swift
plans: [
    .init(
        id: "yearly_premium",
        type: .yearly,
        content: { plan in
            VStack {
                Text("YEARLY")
                Text(plan.price)
            }
        },
        promo: { _ in
            Text("BEST VALUE")
                .padding(4)
                .background(Color.orange)
        }
    )
]
```

### Custom Pay Button

```swift
payButton: .init(
    content: { isTrialEnabled in
        Button(isTrialEnabled ? "Try Free" : "Subscribe") {
            // Purchase action
        }
        .buttonStyle(.borderedProminent)
    },
    caption: { isTrialEnabled in
        Text(isTrialEnabled ? "No Payment Now" : "Cancel Anytime")
            .font(.caption)
    }
)
```

### Custom Footer

```swift
footer: .init(
    content: AnyView(
        HStack {
            Button("Privacy") { /* Open privacy policy */ }
            Text("•")
            Button("Terms") { /* Open terms */ }
        }
    )
)
```

### Handle Purchase Result

```swift
private func handlePurchaseResult(_ result: PurchaseResult, selectedPlan: Plan?) {
    switch result {
    case .success(let verificationResult, _):
        switch verificationResult {
        case .verified:
            // Purchase successful
            dismiss()
        case .unverified:
            // Verification failed
        }
    case .pending:
        // Purchase pending
    case .userCancelled, .unknownError:
        // Handle failure
    }
}
```

### Feature Bullets

```swift
bullets: (
    titles: [
        "✓ Premium features unlocked",
        "✓ Remove ads",
        "✓ Unlimited access"
    ],
    font: .body,
    color: .white
)
```

### Trial Toggle

```swift
trial: .init(
    isEnabled: true,
    selectPlanOnToggle: .weekly,
    onTitle: "Free trial enabled",
    offTitle: "Enable free trial",
    titleColor: .white
)
```

## Contributing

We welcome contributions!
## License

IAPPaywall is available under the MIT license.

## Roadmap

- [ ] Add example project
