//
//  DetailViewController.swift
//  MathQuiz For Third Standard
//
//  Created by  jyotishankar sahoo on 7/12/16.
//  Copyright © 2016  jyotishankar sahoo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var questionHeader: UILabel!
    @IBOutlet weak var questionLabel: UIVerticalAlignLabel!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: Properties
    let darkGreenColor = UIColor(red: 0, green: 128/255, blue: 0, alpha: 1)
    var freezeScore: Bool = false
    var questionList: NSMutableArray!
    var currentIndex: NSInteger = 0
    var currentProblem: Problem!
    var currentScore: NSInteger = 0
    
    var detailItem: String = "Numbers"
    
    var questionNumber: NSInteger {
        return self.currentIndex + 1
    }
    
    var scoreStr: String {
        return NSString(format: "%ld", self.currentScore) as String
    }
    
    var headerStr: String {
        return NSString(format: "Question: %ld of %ld", self.questionNumber, self.questionList.count) as String
    }
    
    // MARK: Fetching
    func fetchQuestionList(chapter: String) -> NSMutableArray {
        let qList: NSMutableArray = []
        var dbList: NSArray?
        if let path = NSBundle.mainBundle().pathForResource(chapter, ofType: "plist") {
            dbList = NSArray(contentsOfFile: path)
        }
        
        if let list = dbList as? Array<Dictionary<String,AnyObject>> {
            var prob :Problem
            for item: Dictionary<String,AnyObject> in list {
                prob = Problem.init()
                prob.question = item["question"] as? String
                prob.answer = item["answer"] as? String
                prob.options = item["options"] as? NSMutableArray
                prob.credit = item["credit"] as? NSInteger
                qList.addObject(prob)
            }
        }
        
        return qList
    }
    
    // MARK: Refresh
    func refreshView() {
        if self.questionList.count > 0 {
            self.currentProblem = self.questionList[self.currentIndex] as! Problem
        }
        dispatch_async(dispatch_get_main_queue()) {
            if self.isViewLoaded() {
                self.questionLabel.text = self.currentProblem.question
                self.questionHeader.text = self.headerStr
                self.comments.text = ""
                self.score.text = self.scoreStr
                
                if let options = self.currentProblem.options {
                    self.topLeftButton.setTitle(options[0] as? String, forState: .Normal)
                    self.topRightButton.setTitle(options[1] as? String, forState: .Normal)
                    self.bottomLeftButton.setTitle(options[2] as? String, forState: .Normal)
                    self.bottomRightButton.setTitle(options[3] as? String, forState: .Normal)
                }
                
                if self.questionNumber > 1 {
                    self.previousButton.setTitle(NSString(format: "Question %ld", self.questionNumber-1) as String, forState: .Normal)
                    self.previousButton.hidden = false
                } else {
                    self.previousButton.hidden = true
                }
                
                if self.questionNumber < self.questionList.count {
                    self.nextButton.setTitle(NSString(format: "Question %ld", self.questionNumber+1) as String, forState: .Normal)
                    self.nextButton.hidden = false
                } else {
                    self.nextButton.hidden = true
                }
            }
        }
    }
    
    func restoreSelection() {
        dispatch_async(dispatch_get_main_queue()) {
            if let selection = self.currentProblem.selectedOption {
                for (index, value) in self.currentProblem.options!.enumerate() {
                    if value as! String == selection {
                        self.freezeScore = true
                        switch index {
                        case 0:
                            self.handleAnswerAction(self.topLeftButton)
                            break
                        case 1:
                            self.handleAnswerAction(self.topRightButton)
                            break
                        case 2:
                            self.handleAnswerAction(self.bottomLeftButton)
                            break
                        case 3:
                            self.handleAnswerAction(self.bottomRightButton)
                            break
                        default:
                            print("Error")
                        }
                    }
                }
            } else {
                self.topLeftButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                self.topRightButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                self.bottomLeftButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                self.bottomRightButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            }
        }
    }
    
    // MARK: View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionList = self.fetchQuestionList(self.detailItem)
        self.currentIndex = 0
        self.navigationItem.title = self.detailItem
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                if self.previousButton.hidden == false {
                    self.goToPrevious(self)
                }
                break
            case UISwipeGestureRecognizerDirection.Left:
                if self.nextButton.hidden == false {
                    self.goToNext(self)
                }
                break
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.score.text = self.scoreStr
        self.refreshView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    @IBAction func goToNext(sender: AnyObject) {
        self.currentIndex = self.currentIndex + 1
        self.refreshView()
        self.restoreSelection()
    }
    
    @IBAction func goToPrevious(sender: AnyObject) {
        self.currentIndex = self.currentIndex - 1
        self.refreshView()
        self.restoreSelection()
    }
    
    @IBAction func answerAction(sender: UIButton) {
        if self.topLeftButton.titleColorForState(.Normal) != self.darkGreenColor &&
            self.topRightButton.titleColorForState(.Normal) != self.darkGreenColor &&
            self.bottomLeftButton.titleColorForState(.Normal) != self.darkGreenColor &&
            self.bottomRightButton.titleColorForState(.Normal) != self.darkGreenColor {
            self.handleAnswerAction(sender)
        } else {
            self.comments.text = "Haha, good try !!"
        }
    }
    
    func handleAnswerAction(sender: UIButton) {
        self.topLeftButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.topRightButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.bottomLeftButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.bottomRightButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        if sender.currentTitle == self.currentProblem.answer {
            sender.setTitleColor(self.darkGreenColor, forState: .Normal)
            if self.freezeScore == false {
                self.currentScore+=3
            } else {
                self.freezeScore = false
            }
        } else {
            sender.setTitleColor(UIColor.redColor(), forState: .Normal)
            if self.freezeScore == false {
                self.currentScore-=1
            } else {
                self.freezeScore = false
            }
        }
        
        self.score.text = self.scoreStr
        let prob = self.questionList[self.currentIndex] as! Problem
        prob.selectedOption = sender.currentTitle
        self.questionList.replaceObjectAtIndex(self.currentIndex, withObject: prob)
        self.currentProblem.selectedOption = sender.currentTitle
    }
}

