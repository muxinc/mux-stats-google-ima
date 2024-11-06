//
//  ContentView.swift
//  MuxStatsGoogleIMAPluginSPMExampleIOS
//

import SwiftUI

struct ContentView: View {
    var title: String

    @State var didPressPlay: Bool = false

    @State var environmentKey: String = ProcessInfo.processInfo.environmentKey ?? ""
    @State var adTagURL: String
    @State var contentURL: String

    @FocusState var environmentKeyTextFieldFocussed: Bool
    @FocusState var adTagURLTextFieldFocussed: Bool
    @FocusState var contentURLTextFieldFocussed: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(
                "Environment Key"
            )
            .frame(alignment: .leading)
            .fontWeight(.bold)
            
            TextField(
                "Environment Key",
                text: $environmentKey,
                axis: .vertical
            )
            .focused($environmentKeyTextFieldFocussed)
            .lineLimit(nil)
            .autocorrectionDisabled()
            .onSubmit {
                environmentKeyTextFieldFocussed = false
            }

            Text(
                "Ad Tag URL"
            )
            .frame(alignment: .leading)
            .fontWeight(.bold)

            TextField(
                "Ad Tag URL",
                text: $adTagURL,
                axis: .vertical
            )
            .focused($adTagURLTextFieldFocussed)
            .lineLimit(nil)
            .autocorrectionDisabled()
            .onSubmit {
                adTagURLTextFieldFocussed = false
            }

            Text(
                "Content URL"
            )
            .frame(alignment: .leading)
            .fontWeight(.bold)

            TextField(
                "Content URL",
                text: $contentURL,
                axis: .vertical
            )
            .focused($contentURLTextFieldFocussed)
            .lineLimit(nil)
            .autocorrectionDisabled()
            .onSubmit {
                contentURLTextFieldFocussed = false
            }

            ZStack {
                PlayerView(
                    title: title,
                    adTagURL: adTagURL,
                    contentURL: contentURL,
                    environmentKey: environmentKey,
                    didPressPlay: $didPressPlay
                )

                Button {
                    didPressPlay = true
                } label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .opacity(didPressPlay ? 0 : 1)
            }
            .aspectRatio(16 / 9, contentMode: .fit)
            .padding()

            Spacer()
        }
        .padding(.top)
        .navigationTitle(title)
    }
}
//
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            title: MenuItem.standardPreRoll.name,
            environmentKey: "",
            adTagURL: MenuItem.standardPreRoll.adTagURL,
            contentURL: MenuItem.standardPreRoll.contentURL
        )
    }
}

private struct PlayerView: UIViewControllerRepresentable {
    var title: String
    var adTagURL: String
    var contentURL: String
    var environmentKey: String

    typealias UIViewControllerType = PlayerContainerViewController
    @Binding var didPressPlay: Bool

    func makeUIViewController(context: Context) -> PlayerContainerViewController {
        let viewController = PlayerContainerViewController()
        viewController.adTagURLString = adTagURL
        viewController.contentURLString = contentURL
        viewController.environmentKey = environmentKey
        viewController.title = title
        return viewController
    }

    func updateUIViewController(
        _ uiViewController: PlayerContainerViewController,
        context: Context
    ) {
        if didPressPlay {
            uiViewController.playButtonPressed()
        }
        uiViewController.adTagURLString = adTagURL
        uiViewController.contentURLString = contentURL
        uiViewController.environmentKey = environmentKey
        uiViewController.title = title
    }
}
