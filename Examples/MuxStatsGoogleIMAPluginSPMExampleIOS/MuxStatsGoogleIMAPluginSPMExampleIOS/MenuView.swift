//
//  MenuView.swift
//  MuxStatsGoogleIMAPluginSPMExampleIOS
//

import SwiftUI



struct MenuItemView: View {
    var item: MenuItem

    var body: some View {
        ContentView(
            title: item.name,
            adTagURL: item.adTagURL,
            contentURL: item.contentURL
        )
    }
}

struct MenuView: View {
    var items: [MenuItem] = [
        .standardPreRoll,
        .skippablePreRoll,
        .postRoll,
        .adRules,
        .vmapPods,
        .custom
    ]

    var body: some View {
        NavigationView {
            List(items) { item in
                NavigationLink(
                    destination: MenuItemView(
                        item: item
                    )
                ) {
                    Text(item.name)
                }
            }
            .navigationTitle("IMA Ad Tag Variants")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}

