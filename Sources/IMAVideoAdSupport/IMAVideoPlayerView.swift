//
//  IMAVideoPlayerView.swift
//  IMAVideoAdSupport
//
//  Created by Waveline on 19/03/2025.
//


import UIKit
import AVKit
import GoogleInteractiveMediaAds

public class IMAVideoPlayerView: UIView {

    private var player: AVPlayer!
    private var adManager: IMAVideoAdManager?
    private var playerViewController: AVPlayerViewController!
    private let adTagURL: String
    private let rootViewController: UIViewController!
    private weak var delegate: IMAVideoAdDelegate?

    public init(player: AVPlayer, adTagURL: String, rootViewController: UIViewController, delegate: IMAVideoAdDelegate?) {
        self.player = player
        self.adTagURL = adTagURL
        self.rootViewController = rootViewController
        self.delegate = delegate
        super.init(frame: .zero)
        setupVideoPlayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 🔹 Handle layout updates dynamically
    public override func layoutSubviews() {
        super.layoutSubviews()
        playerViewController.view.frame = bounds
    }

    private func setupVideoPlayer() {
        // Initialize AVPlayerViewController
        playerViewController = AVPlayerViewController()
        //player.play()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = true  // Automatically shows playback controls like play/pause, scrubber, etc.


        // Add the AVPlayerViewController's view as a subview to the custom UIView
        addSubview(playerViewController.view)

    }
    
    /// This is called when the view is added to a window (i.e., it's on screen)
       public override func didMoveToWindow() {
           super.didMoveToWindow()
           if window != nil { // View is in the view hierarchy
               requestAdsIfNeeded()
           }
       }

       private func requestAdsIfNeeded() {
           if adManager == nil {
               adManager = IMAVideoAdManager(player: player, delegate: delegate)
               adManager?.requestAds(adTagURL: adTagURL, videoView: self, viewController: rootViewController)
           }
       }

}
