//
//  ViewController.swift
//  NS-Elem-1
//
//  Created by Eric Hernandez on 12/2/18.
//  Copyright © 2018 Eric Hernandez. All rights reserved.
// once the user presses the check button, it should print out the number of questions they have done in the debug console

import UIKit
import Speech
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerTxt: UITextField!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var questionNumberLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    var randomPick: Int = 0
    var correctAnswers: Int = 0
    var numberAttempts: Int = 0
    var timer = Timer()
    var counter = 0.0
    var randomNumA : Int = 0
    var randomNumB : Int = 0
    var randomNumC : Int = 0
    var firstNum : Int = 0
    var secondNum : Int = 0
    var thirdNum : Int = 0
    var questionTxt : String = ""
    var answerCorrect : Int = 0
    var answerUser : Int = 0
    var questionNumber = 0
    var averageSecond = 0
    //MARK: - Add 3
    var currentAvgTime = 0
    var modUserName3 = ""
    var timerTouch = Timer()
    let category = "1A1"
    var counterTouch = 0.0
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five", "You are so smart"]
    let retryArray = ["Oooops", "Try again"]
    let getBackToWorkArray = ["You know what your dad wants to hear!","Your dad is waiting!","Don't get penalize","Life is a race","Who is winning the race?","Guess what Lucas and Tony are doing?","I will tell your dad","Remember the story of the Turtle and Rabbit","Don't forget to love yourself"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - add getUserName
        getUserName()
        setImproperlyClosedToN()
        askQuestion()

        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)

        self.answerTxt.becomeFirstResponder()
    }

    @IBAction func checkAnswerByUser(_ sender: Any) {
        checkAnswer()
    }
    //MARK: - Get userName
    func getUserName(){

        let userName = Auth.auth().currentUser?.email as! String
        let modUserName1 = userName.replacingOccurrences(of: "@", with: "")
        let modUsername2 = modUserName1.replacingOccurrences(of: ".", with: "")
        modUserName3 = modUsername2
    }
    func askQuestion(){
        //TODO: Stop the timer when the user is done with the 5th question.
        
        if correctAnswers == 2{
            //MARK: - Replace questionNumber with correctAnswers
            averageSecond = Int(counter)/correctAnswers
            timer.invalidate()
            timerTouch.invalidate()
            stopTimer()
            //MARK: - Replace updateAvgTime with getAvgTimeFromDB
            compareTime()

        } else {
        
        //3 digit questions starting at 100
//        randomNumA = Int.random(in: 100 ..< 1001)
//        randomNumB = Int.random(in: 100 ..< 1001)
//        randomNumC = Int.random(in: 100 ..< 1001)
        
        randomNumA = Int.random(in: 1 ..< 11)
        randomNumB = Int.random(in: 1 ..< 11)
        randomNumC = Int.random(in: 1 ..< 11)
            
        questionLabel.text = "\(randomNumA) + \(randomNumB) + \(randomNumC)"
        questionNumber += 1
        startTimerTouch()
        }
    }
    func failed(){
        let alert = UIAlertController(title: "Redo!", message: "You could do better... try again!", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Start Over", style: .default) { (handler) in
            self.startOver()
        }
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }
    func breakNewRecord(){
        let alert = UIAlertController(title: "Want to beat your new record!", message: "Come on... you can do it!", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Break My New Record", style: .default) { (handler) in
            self.startOver()
        }
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }
    func compareTime(){
        //Get Previous Record
        let refPrevRec = Database.database().reference().child("Users").child(modUserName3).child(category).child("AvgTime")
        refPrevRec.observeSingleEvent(of: .value, with: {(snapshot) in
            self.currentAvgTime = (snapshot.value as? Int)!
            // Compare New Time with Previous Record Time
            if self.averageSecond >= self.currentAvgTime{
                self.questionLabel.text = "Nope! Your time of \(self.averageSecond) needs to be less than your record of \(self.currentAvgTime)."
                self.readMe(myText: "Redo!")
                self.failed()
            } else {
                self.updateDB()
                self.questionLabel.text = "Yes! Your time of \(self.averageSecond) is better than your record of \(self.currentAvgTime)."
                self.readMe(myText: "Record broken!")
                self.breakNewRecord()
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    func updateDB(){
        //MARK: - Fix
        let refUserNameDB = Database.database().reference().child("Users").child(modUserName3).child(category)
        refUserNameDB.setValue(["AvgTime": averageSecond, "Date": getCurrentShortDate()]){
            (error,reference) in
            if error != nil{
                print(error!)
            } else {
                print("Message saved successfully!")
                
            }
        }
    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touchCount = touches.count
//        let touch = touches.first
//        let tapCount = touch!.tapCount
//
//        //categoryTxt.text = "touchesEnded";
//        //timeTxt.text = "\(touchCount) touches"
//        //userNameTxt.text = "\(tapCount) taps"
//        print("stopped touching")
//
//        startTimerTouch()
//    }
    func startTimerTouch(){
        counterTouch = 0
        //userNameTxt.text = "\(counter)"
        timerTouch = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateTimerTouch), userInfo: nil, repeats: true)
    }
    func stopTimerTouch(){
        timerTouch.invalidate()
    }
    @objc func updateTimerTouch(){
        counterTouch += 1
        if counterTouch == 20{
            randomBackToWork()
            counterTouch = 0
        }
        
    }
    func randomBackToWork(){
        let randomPickWork = Int(arc4random_uniform(8))
        readMe(myText: getBackToWorkArray[randomPickWork])
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touchCount = touches.count
//        let touch = touches.first
//        let tapCount = touch!.tapCount
//
//       // categoryTxt.text = "touchesBegan"
//        //timeTxt.text = "\(touchCount) touches"
//        //userNameTxt.text = "\(tapCount) taps"
//        print("start touching")
//        stopTimerTouch()
//    }
    func setImproperlyClosedToN(){
        let improperlyClosedDB = Database.database().reference().child("Users").child(modUserName3)
        
        improperlyClosedDB.updateChildValues(["ImproperlyClosed": "N"]){
            (error,reference) in
            if error != nil{
                print(error!)
            } else {
                print("Message saved successfully!")
                
            }
            
        }
    }
    func startOver(){
        counter = 0
        correctAnswers = 0
        numberAttempts = 0
        questionNumber = 0
        askQuestion()
        
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        self.answerTxt.becomeFirstResponder()
    }
    
    func checkAnswer(){
        //MARK: - Add
        stopTimerTouch()
        answerUser = (answerTxt.text! as NSString).integerValue
        answerCorrect = randomNumA + randomNumB + randomNumC
        
        if answerCorrect == answerUser {
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
            randomPositiveFeedback()
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                //next problem
                self.askQuestion()
                self.answerTxt.text = ""
                
            }
        }
        else{
            randomTryAgain()
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
        }
    }
    
    @objc func updateTimer(){
        counter += 0.1
        timerLbl.text = String(format:"%.1f",counter)
    }
    
    func readMe( myText: String) {
        let utterance = AVSpeechUtterance(string: myText )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func randomPositiveFeedback(){
        randomPick = Int(arc4random_uniform(10))
        readMe(myText: congratulateArray[randomPick])
    }
    
    func updateProgress(){
        progressLbl.text = "\(correctAnswers) / \(numberAttempts)"
    }
    
    func randomTryAgain(){
        randomPick = Int(arc4random_uniform(2))
        readMe(myText: retryArray[randomPick])
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    func getCurrentShortDate() -> String {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let DateInFormat = dateFormatter.string(from: todaysDate)
        
        return DateInFormat
    }
    
}

