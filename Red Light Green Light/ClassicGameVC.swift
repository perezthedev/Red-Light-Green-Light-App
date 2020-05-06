//
//  ClassicGame.swift
//  Red Light v06
//
//  Created by Ryan Aponte on 4/10/20.
//  Copyright © 2020 RCBTechnologies. All rights reserved.
//
// App ID: ca-app-pub-1677569443681208~5026346537
//
// Ad Unit ID: ca-app-pub-1677569443681208/2608469706

import Foundation
import UIKit
import SpriteKit
import GoogleMobileAds


class ClassicGameVC: UIViewController {
    
    @IBOutlet var greenLight: UIImageView!
    @IBOutlet var redLight: UIImageView!
    @IBOutlet var buzzerButton: BuzzerButton!
    @IBOutlet var scoreLbl: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var highScoreLbl: UILabel!
    @IBOutlet var gameLightLbl: UIImageView!
    
    
    var hasGameStarted = false // used once to trigger timer
    var timer: Timer!
    var flag = false // to check if game ended
    
    var classicHighScore = 0
    var hardHighScore = 0
    var insaneHighScore = 0
    
    var randomNum = 0
    var score = 0
    let blackColor = UIColor.black
    let whiteColor = UIColor.white
    
    var timeIntervalVal = 0.0
    
    @IBOutlet weak var gameBannerAd: GADBannerView!
    
    
    
    override func viewDidLoad() {
        gameLightLbl.layer.borderWidth = 5.0
        gameLightLbl.layer.borderColor = whiteColor.cgColor
        score = 0
        buzzerButton.initButton()
        greenLight.layer.isHidden = true
        redLight.layer.isHidden = true
        scoreLbl.adjustsFontSizeToFitWidth = true
        highScoreLbl.adjustsFontSizeToFitWidth = true
        scoreLbl.text = "Score: \(score)"
        restartButton.layer.isHidden = true
        buzzerButton.layer.isHidden = false
        hasGameStarted = false
        flag = false
        
        // Banner Ad
        gameBannerAd.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        gameBannerAd.rootViewController = self
        gameBannerAd.load(GADRequest())
        
        //switch/break for difficulty selected
        switch ViewController.levelDifficulty{
        case 1: // classic
            timeIntervalVal = 1.0
            //high score
            let classicHighScoreDefault = UserDefaults.standard
               
            if (classicHighScoreDefault.value(forKey: "classicHighScore") != nil){
                classicHighScore = classicHighScoreDefault.value(forKey: "classicHighScore") as! NSInteger
                highScoreLbl.text = NSString(format: "High Score: %i", classicHighScore) as String
            }
            
        case 2: // hard
            timeIntervalVal = 0.5
            let hardHighScoreDefault = UserDefaults.standard
               
            if (hardHighScoreDefault.value(forKey: "hardHighScore") != nil){
                hardHighScore = hardHighScoreDefault.value(forKey: "hardHighScore") as! NSInteger
                highScoreLbl.text = NSString(format: "High Score: %i", hardHighScore) as String
            }
            
        case 3: // insane
            timeIntervalVal = 0.2
            let insaneHighScoreDefault = UserDefaults.standard
               
            if (insaneHighScoreDefault.value(forKey: "insaneHighScore") != nil){
                insaneHighScore = insaneHighScoreDefault.value(forKey: "insaneHighScore") as! NSInteger
                highScoreLbl.text = NSString(format: "High Score: %i", insaneHighScore) as String
            }
            
        default:
            break
        }
        
//        let classicHighScoreDefault = UserDefaults.standard
//
//        if (classicHighScoreDefault.value(forKey: "HighScore") != nil){
//            highScore = classicHighScoreDefault.value(forKey: "HighScore") as! NSInteger
//            highScoreLbl.text = NSString(format: "High Score: %i", highScore) as String
//        }
        
       
        
    }
    
//    func lvlDifficulty(mode: Double){
//        levelDifficulty = mode
//    }
    
    @IBAction func startButton(_ sender: Any) {
        
        if !hasGameStarted{
            greenLight.layer.isHidden = false
            hasGameStarted = true
            //lightToggle()
            
            //let tempVC = ViewController()
            timer = Timer.scheduledTimer(timeInterval: timeIntervalVal, target: self, selector: #selector(lightToggle), userInfo: nil, repeats: true)
            
        }
        //hasBuzzerBeenPressed = true
        
        //checks if game over state
        if(flag){ gameEnded() }
        else{
            //otherwise update score
            score += 1
            scoreLbl.text = "Score: \(score)"
        }

    }
    
    @IBAction func restartTapped(_ sender: Any) {
        viewDidLoad()
    }
    
    
    @objc func lightToggle() -> Bool{
        
        randomNum = Int.random(in: 0...10)
        
        //!!!!!!!!!!!!!!!!!!!!
        if(randomNum != 5 && randomNum != 7 && randomNum != 9 && randomNum != 10) {
            
            //red
            greenLight.layer.isHidden = false
            redLight.layer.isHidden = true
            //hasBuzzerBeenPressed = false
            flag = false

        } else {
            //green
            greenLight.layer.isHidden = true
            redLight.layer.isHidden = false
            flag = true
        }
        return flag
    }
    
    func gameEnded(){
        buzzerButton.layer.isHidden = true
        timer.invalidate() //stops light once lost
        restartButton.isHidden = false
        restartButton.layer.borderWidth = 5.0
        restartButton.layer.borderColor = whiteColor.cgColor
        restartButton.backgroundColor = blackColor
        restartButton.layer.cornerRadius = restartButton.frame.size.height/2
        updateHighScore()
       // saves new high score
        
    }
    
    func updateHighScore(){
        
        switch ViewController.levelDifficulty{
        case 1:
            if (score > classicHighScore){
                classicHighScore = score
                highScoreLbl.text = "High Score: \(score)"
                
                let classicHighScoreDefault = UserDefaults.standard
                classicHighScoreDefault.setValue(classicHighScore, forKey: "classicHighScore")
                classicHighScoreDefault.synchronize()
            }
        case 2:
            if (score > hardHighScore){
                hardHighScore = score
                highScoreLbl.text = "High Score: \(score)"
                
                let hardHighScoreDefault = UserDefaults.standard
                hardHighScoreDefault.setValue(hardHighScore, forKey: "hardHighScore")
                hardHighScoreDefault.synchronize()
            }
            
        case 3:
            if (score > insaneHighScore){
                insaneHighScore = score
                highScoreLbl.text = "High Score: \(score)"
                
                let insaneHighScoreDefault = UserDefaults.standard
                insaneHighScoreDefault.setValue(insaneHighScore, forKey: "insaneHighScore")
                insaneHighScoreDefault.synchronize()
            }
            
        default:
            break
        }
    }
}

