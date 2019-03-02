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
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five", "You are so smart"]
    let retryArray = ["Oooops", "Try again"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        askQuestion()
        
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        self.answerTxt.becomeFirstResponder()
    }

    @IBAction func checkAnswerByUser(_ sender: Any) {
        checkAnswer()
    }
    
    func askQuestion(){
        //TODO: Stop the timer when the user is done with the 5th question.
        if correctAnswers == 5{
            averageSecond = Int(counter)/questionNumber
            questionLabel.text = "Your average time is \(averageSecond) seconds."
            updateAvgTime()
            timer.invalidate()
            stopTimer()
            
            if averageSecond >= 8 {
                let alert = UIAlertController(title: "Redo!", message: "You did not finish in less than 8 seconds!", preferredStyle: .alert)
                let restartAction = UIAlertAction(title: "Start Over", style: .default) { (handler) in
                    self.startOver()
                }
                alert.addAction(restartAction)
                present(alert, animated: true, completion: nil)
            } else {
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.readMe(myText: "Congratulations! Your average time is \(self.averageSecond) seconds.")
                    self.questionLabel.text = "Congratulations! Your average time is \(self.averageSecond) seconds."
                }
            }

            
        }
        
        //3 digit questions starting at 100
        randomNumA = Int.random(in: 100 ..< 1001)
        randomNumB = Int.random(in: 100 ..< 1001)
        randomNumC = Int.random(in: 100 ..< 1001)
        
        questionLabel.text = "\(randomNumA) + \(randomNumB) + \(randomNumC)"
        questionNumber += 1
    

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
    func updateAvgTime(){
        let category = "1A1"
        let userName = Auth.auth().currentUser?.email as! String
        let modUserName1 = userName.replacingOccurrences(of: "@", with: "")
        let modUsername2 = modUserName1.replacingOccurrences(of: ".", with: "")
        let refUserNameDB = Database.database().reference().child("Users").child(modUsername2).child(category)
        
        
        refUserNameDB.setValue(["AvgTime": averageSecond, "Date": getCurrentShortDate()]){
            (error,reference) in
            if error != nil{
                print(error!)
            } else {
                print("Message saved successfully!")
                
            }
        }
    }
    
    func getCurrentShortDate() -> String {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let DateInFormat = dateFormatter.string(from: todaysDate)
        
        return DateInFormat
    }
    
}

