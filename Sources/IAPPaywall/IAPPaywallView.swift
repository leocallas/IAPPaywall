// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

struct IAPPaywallView: View {

    @Binding var model: IAPPaywallModel

    var body: some View {
        ScrollView {
            VStack {
                IAPPaywallHeaderView(model: $model)
                IAPPaywallContentView(model: $model)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .scrollIndicators(.hidden)

        IAPPaywallFooterView(model: $model)
    }
}

#Preview {
    IAPPaywallView(model: .constant(
        .init(
            title: .init(
                title: "Your Creativity Journey Starts Here",
                font: .largeTitle.bold(),
                color: .black
            ),
            subTitle: .init(
                subTitle: "Unlock our full gallery of premium resources",
                font: .body,
                color: .black
            ),
            header: .init(
                title: "Subscription",
                font: .body,
                color: .black,
                image: .init("verticalImage"),
                isSticky: true,
                isStretchy: true
            ),
            points: [
                .init(
                    icon: .init("CheckMark"),
                    title: "Unlock premium art tutorial and resources",
                    font: .body,
                    color: .black
                ),
                .init(
                    icon: .init("CheckMark"),
                    title: "Downloadable art materials",
                    font: .body,
                    color: .black
                ),
                .init(
                    icon: .init("CheckMark"),
                    title: "Supports the creative work",
                    font: .body,
                    color: .black
                )
            ],
            payButton: .init(
                title: "Continue",
                titleColor: .white,
                backgroundColor: .black,
                caption: .init(title: "Get full access for just $12.99/yr", font: .caption, color: Color.gray)
            ),
            footerLinks: [
                .init(
                    title: "Restore",
                    titleColor: .black,
                    action: {
                        
                    }),
                .init(
                    title: "Terms & Conditions",
                    titleColor: .black,
                    action: {
                        
                    }),
                .init(
                    title: "Privacy",
                    titleColor: .black,
                    action: {
                        
                    })
            ]
        )
    ))
}
