//
//  ContentView.swift
//  MuxStatsGoogleIMAPluginSPMExampleIOS
//

import SwiftUI

struct ContentView: View {
  @State var didPressPlay: Bool = false

  var body: some View {
    VStack {
      Text("IMA SDK Basic Example App")

      ZStack {
        PlayerView(didPressPlay: $didPressPlay)

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
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

private struct PlayerView: UIViewControllerRepresentable {
  typealias UIViewControllerType = PlayerContainerViewController
  @Binding var didPressPlay: Bool

  func makeUIViewController(context: Context) -> PlayerContainerViewController {
    return PlayerContainerViewController()
  }

  func updateUIViewController(_ uiViewController: PlayerContainerViewController, context: Context) {
    if didPressPlay {
      uiViewController.playButtonPressed()
    }
  }
}
