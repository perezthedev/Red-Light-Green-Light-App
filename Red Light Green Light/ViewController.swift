//
//  ViewController.swift
//  Red Light v06
//
//  Created by Ryan Aponte on 4/8/20.
//  Copyright © 2020 RCBTechnologies. All rights reserved.
//
//
// App Id: ca-app-pub-1677569443681208~5026346537
// Unit Id: ca-app-pub-1677569443681208/1601853251
//
//Banner Size should be 320 width x 50 height

import UIKit
import AVFoundation
import GameKit
import GoogleMobileAds


class ViewController: UIViewController, GKGameCenterControllerDelegate {

    // 1 - Classic (Default)
    // 2 - Hard
    // 3 - Insane
    static var levelDifficulty = 1 // default: classic mode
    
    @IBOutlet weak var homeBanner: GADBannerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeBannerAdLayout()
        titleLabel.adjustsFontSizeToFitWidth = true
        //homeBanner.addConstraint(height)
    }
    
    //prevents app from rotating
    //also changed settings in info -> custom iOS target properties -> Supported Interface Orientations
    override var shouldAutorotate: Bool { return false }
    
    @IBAction func classicMode(_ sender: Any) {
        ViewController.levelDifficulty = 1
    }
    
    @IBAction func hardMode(_ sender: Any) {
        ViewController.levelDifficulty = 2
    }
    
    @IBAction func insaneMode(_ sender: Any) {
        ViewController.levelDifficulty = 3
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let shareButtonVC = UIActivityViewController(activityItems: ["google.com"], applicationActivities: nil)
        shareButtonVC.popoverPresentationController?.sourceView = self.view
        self.present(shareButtonVC, animated: true, completion: nil)
    }
    
    func authPlayer(){
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {
            (view, Error) in
            if view != nil{
                self.present(view!, animated: true, completion: nil)
            } else {
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
    
    //VC does not conform to protocol of GKGameCenter delegate vvv
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func homeBannerAdLayout(){
        homeBanner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        homeBanner.rootViewController = self
        homeBanner.load(GADRequest())
    }
}

