//
//  IMAVideoAdManager.swift
//  IMAVideoAdSupport
//
//  Created by Waveline on 17/03/2025.
//

import UIKit
import AVKit
import GoogleInteractiveMediaAds


public protocol IMAVideoAdDelegate: AnyObject {
    func adDidStart()
    func adDidClick()
    func adDidSkip()
    func adDidComplete()
    func adDidFail(error: String)
    func contentPause()
    func contentResume()
}

public class IMAVideoAdManager: NSObject {

    private var player: AVPlayer?
    private var adsLoader: IMAAdsLoader?
    private var adsManager: IMAAdsManager?
    private var contentPlayhead: IMAAVPlayerContentPlayhead?
    private weak var delegate: IMAVideoAdDelegate?

    public init(player: AVPlayer?, delegate: IMAVideoAdDelegate?) {
        super.init()
        self.player = player
        self.delegate = delegate
        setupIMA()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupIMA() {
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader?.delegate = self
        observeVideoPlaying()
    }

    //You also need to let the SDK know when your content is done playing so it can display post-roll ads
    private func observeVideoPlaying() {
        NotificationCenter.default.addObserver(
             self,
             selector: #selector(contentDidFinishPlaying(_:)),
             name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
             object: player?.currentItem)
    }

    public func requestAds(adTagURL: String, videoView: UIView, viewController: UIViewController) {
        guard let player = player else { return }

        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: videoView, viewController: viewController)
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: player)

        let adRequest = IMAAdsRequest(
            adTagUrl: adTagURL,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)

        adsLoader?.requestAds(with: adRequest)
    }
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        adsLoader?.contentComplete()
      }
}

// MARK: - IMAAdsLoaderDelegate
extension IMAVideoAdManager: IMAAdsLoaderDelegate {

    public func adsLoader(_ loader: IMAAdsLoader, adsLoadedWith adsLoadedData: IMAAdsLoadedData) {

        adsManager = adsLoadedData.adsManager
        adsManager?.delegate = self
        adsManager?.initialize(with: nil)
    }

   public func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {

        self.delegate?.adDidFail(error: adErrorData.adError.message ?? "")
    }
}

// MARK: - IMAAdsManagerDelegate
extension IMAVideoAdManager: IMAAdsManagerDelegate {

    public func adsManager(_ adsManager: IMAAdsManager, didReceive event: IMAAdEvent) {
        switch event.type {
        case .LOADED:
               adsManager.start()
                self.delegate?.adDidStart()
        case .CLICKED:
                self.delegate?.adDidClick()
        case .SKIPPED:
                self.delegate?.adDidSkip()
        case .COMPLETE:
                self.delegate?.adDidComplete()
        default:
            break
        }
    }

    // Handle ad errors
    public func adsManager(_ adsManager: IMAAdsManager, didReceive error: IMAAdError) {
        print("IMA Ad Error: \(error.message ?? "")")
        self.delegate?.adDidFail(error: error.message ?? "")
    }

    // Pause the content when an ad starts
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {
           print("Content should pause now")
        self.delegate?.contentPause()
    }

    // Resume the content when an ad finishes
    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {
        print("Content should resume now")
        self.delegate?.contentResume()
    }
}
