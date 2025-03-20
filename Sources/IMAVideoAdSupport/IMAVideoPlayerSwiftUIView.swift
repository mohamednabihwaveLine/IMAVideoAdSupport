//
//  IMAVideoPlayerSwiftUIView.swift
//  IMAVideoAdSupport
//
//  Created by Waveline on 17/03/2025.
//

import SwiftUI
import AVFoundation


public struct IMAVideoPlayerSwiftUIView: UIViewRepresentable {
    let player: AVPlayer
    let adTagURL: String
    let delegate: IMAVideoAdDelegate
    var rootViewController: UIViewController

    public init(player: AVPlayer, adTagURL: String, delegate: IMAVideoAdDelegate, rootViewController: UIViewController) {
        self.player = player
        self.adTagURL = adTagURL
        self.delegate = delegate
        self.rootViewController = rootViewController
    }

    public func makeUIView(context: Context) -> IMAVideoPlayerView {
        // Initialize IMAVideoPlayerView with player and adTagURL
        let videoPlayerView = IMAVideoPlayerView(player: player, adTagURL: adTagURL, rootViewController: rootViewController, delegate: delegate)
        return videoPlayerView
    }

    public func updateUIView(_ uiView: IMAVideoPlayerView, context: Context) {
        // Optionally update your view if needed
    }

    // Create the Coordinator to handle the rootViewController if needed (for ad management or other purposes)
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    // Optional Coordinator class to manage the communication between SwiftUI and UIKit if needed
    public class Coordinator: NSObject {
        // You can handle any necessary actions here, such as interacting with view controller lifecycle.
    }
}

