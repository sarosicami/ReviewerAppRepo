//
//  AddReviewViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/12/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class AddReviewViewController : UIViewController, UITextViewDelegate, NetworkServiceDelegate {
    
    @IBOutlet weak var addReviewTableView: UITableView!
    @IBOutlet weak var arrowImageView: UIImageView!
    var loggedUser = User()
    var product = Product()
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var summaryButton: UIButton!
    @IBOutlet weak var postReviewButton: UIButton!
    
    var opinionsList = [Opinion]()
    var polaritiesTuple = [(polarity:String, polarityTuple: [(emotion: String, emotionTuple: [(category: String, opinionsText: [String])])])]()
    var indexPos = Int()
    var indexNeg = Int()
    var emotionIndexes = [(emotion:String, index:Int)]()
    var categoryIndexes = [(category:String, index:Int)]()
    var opinionTextIndexes = [(opinionText:String, index:Int)]()
    var positiveEmotionIndexes = [(emotion:String,index:Int)]()
    var positiveCategoryIndexes = [(category:String,index:Int)]()
    var positiveOpinionTextIndexes = [(opinionText:String, index:Int)]()
    var negativeEmotionIndexes = [(emotion:String,index:Int)]()
    var negativeCategoryIndexes = [(category:String, index:Int)]()
    var negativeOpinionTextIndexes = [(opinionText:String, index:Int)]()
    
    var reviewForSummary = String()
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        self.addReviewTableView.layoutMargins = UIEdgeInsetsZero
        self.addReviewTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.addReviewTableView.tableFooterView = UIView()
        
        let tbvc = self.tabBarController  as! ReviewsTabBarController
        self.loggedUser = tbvc.loggedUser
        self.product = tbvc.product
        
        reviewTextView.delegate = self
        reviewTextView.autocorrectionType = UITextAutocorrectionType.No;
        
        summaryButton.userInteractionEnabled = false;
        postReviewButton.userInteractionEnabled = false;
        
        summaryButton .setTitleColor(UIColor(red:150.0/255.0, green:150.0/255.0, blue:150.0/255.0, alpha:1.0), forState: .Normal)
        postReviewButton .setTitleColor(UIColor(red:150.0/255.0, green:150.0/255.0, blue:150.0/255.0, alpha:1.0), forState: .Normal)
        
        self.addReviewTableView.hidden = true
        self.activityIndicator.hidden = true
        
        // configure table view to have cells with dynamic height
        addReviewTableView.rowHeight = UITableViewAutomaticDimension
        addReviewTableView.estimatedRowHeight = 21.0
    }
    
    override func viewDidAppear(animated: Bool) {
        let tbvc = self.tabBarController  as! ReviewsTabBarController
        tbvc.title = "Add Review"
    }
   
    @IBAction func onPostReview(sender: AnyObject) {
        let service = NetworkService ()
        service.delegate = self
        let stringUserId = String(loggedUser.id!)
        print(stringUserId)
        let stringProductId = String(product.id!)
        let addReviewDict = ["user_id":stringUserId, "product_id":stringProductId, "review_text":reviewTextView.text]
        self.showActivityIndicator()
        service.addReviewWithDict(addReviewDict)
    }
    
    @IBAction func onDisplaySummary(sender: AnyObject) {
        if !(opinionsList.count > 0) || reviewForSummary != reviewTextView.text {
            let service = NetworkService ()
            service.delegate = self
            let stringUserId = String(loggedUser.id!)
            let stringProductId = String(product.id!)
            let reviewSummaryDict = ["user_id":stringUserId, "product_id":stringProductId, "review_text":reviewTextView.text]
            self.showActivityIndicator()
            service.getReviewSummaryWithDict(reviewSummaryDict)
            reviewForSummary = reviewTextView.text;
        } else {
            if summaryButton.titleLabel?.text == "See Summary" {
                self.summaryButton.setTitle("Hide Summary", forState: .Normal)
                self.arrowImageView.image = UIImage(named: "arrow_up")
                self.addReviewTableView.hidden = false
            } else {
                self.summaryButton.setTitle("See Summary", forState: .Normal)
                self.arrowImageView.image = UIImage(named: "arrow_down")
                self.addReviewTableView.hidden = true
            }
        }
    }
    
    
    // MARK: Network-Service delegate methods
    func didReceiveResponseForAddReviewWithDict(info:NSDictionary) {
        let errorMessage = info.valueForKey("error") as? String
        if !errorMessage!.isEmpty {
            dispatch_async(dispatch_get_main_queue(), {
                self.stopActivityIndicator()
                let alertMessage = UIAlertController(title: "", message:errorMessage, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default,  handler: { (action: UIAlertAction!) in
                    self.reviewTextView.text = ""
                    self.opinionsList = [Opinion]()
                    self.summaryButton.userInteractionEnabled = false;
                    self.postReviewButton.userInteractionEnabled = false;
                    self.summaryButton.setTitle("See Summary", forState: .Normal)
                    self.arrowImageView.image = UIImage(named: "arrow_down")
                    self.addReviewTableView.reloadData()
                    
                    self.summaryButton .setTitleColor(UIColor(red:150.0/255.0, green:150.0/255.0, blue:150.0/255.0, alpha:1.0), forState: .Normal)
                    self.postReviewButton .setTitleColor(UIColor(red:150.0/255.0, green:150.0/255.0, blue:150.0/255.0, alpha:1.0), forState: .Normal)
                })
                alertMessage.addAction(defaultAction)
                self.presentViewController(alertMessage, animated: true, completion: nil)
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.stopActivityIndicator()
                let alertMessage = UIAlertController(title: "", message:"Your review was successfully registered" as String, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default,  handler: nil)
                alertMessage.addAction(defaultAction)
                self.presentViewController(alertMessage, animated: true, completion: nil)
            })
        }
    }
    
    func didReceiveResponseForSeeReviewSummaryWithDict(opinionsDict:NSDictionary) {
        print("Info dictionary:\( opinionsDict )")
        opinionsList = [Opinion]()
        
        if let opinions = opinionsDict.valueForKey("opinions") as? [NSDictionary] {
            for opinionDict in opinions {
                let opinion = Opinion(dict:opinionDict)
                opinionsList.append(opinion)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.stopActivityIndicator()
            self.summaryButton.setTitle("Hide Summary", forState: .Normal)
            self.arrowImageView.image = UIImage(named: "arrow_up")
            self.extractOpinionsInfo()
        })
    }
    
    func didFailToReceiveResponseWithMessage(failureMessage:NSString) {
        dispatch_async(dispatch_get_main_queue(), {
            self.stopActivityIndicator()
            let alertMessage = UIAlertController(title: "", message:failureMessage as String, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if range.location == 0 {
            if range.length == 0 && !text.isEmpty {
                summaryButton.userInteractionEnabled = true;
                postReviewButton.userInteractionEnabled = true;
                summaryButton .setTitleColor(UIColor(red:0.0/255.0, green:122.0/255.0, blue:255.0/255.0, alpha:1.0), forState: .Normal)
                postReviewButton .setTitleColor(UIColor(red:0.0/255.0, green:122.0/255.0, blue:255.0/255.0, alpha:1.0), forState: .Normal)
            } else if range.length == 1 && text.isEmpty {
                self.opinionsList = [Opinion]()
                self.addReviewTableView.reloadData()
                summaryButton.userInteractionEnabled = false;
                postReviewButton.userInteractionEnabled = false;
                self.summaryButton.setTitle("See Summary", forState: .Normal)
                self.arrowImageView.image = UIImage(named: "arrow_down")
                summaryButton .setTitleColor(UIColor(red:150.0/255.0, green:150.0/255.0, blue:150.0/255.0, alpha:1.0), forState: .Normal)
                postReviewButton .setTitleColor(UIColor(red:150.0/255.0, green:150.0/255.0, blue:150.0/255.0, alpha:1.0), forState: .Normal)
            }
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if !reviewTextView.text.isEmpty && reviewTextView.text != reviewForSummary {
            self.summaryButton.setTitle("See Summary", forState: .Normal)
            self.arrowImageView.image = UIImage(named: "arrow_down")
            self.addReviewTableView.hidden = true;
        }
    }
    
    // MARK: TableView delegate & datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if opinionsList.count > 0 {
            return 2
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if opinionsList.count > 0 {
            if section == 0 {
                return indexPos
            } else if section == 1 {
                return indexNeg
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = UITableViewCell()
            if indexPath.section == 0 {
                emotionIndexes = positiveEmotionIndexes
                categoryIndexes = positiveCategoryIndexes
                opinionTextIndexes = positiveOpinionTextIndexes
            } else if indexPath.section == 1 {
                emotionIndexes = negativeEmotionIndexes
                categoryIndexes = negativeCategoryIndexes
                opinionTextIndexes = negativeOpinionTextIndexes
            }
            if opinionsList.count > 0 {
                for (emotion, emotionIndex) in emotionIndexes {
                    if (indexPath.row == emotionIndex) {
                        let cell = tableView.dequeueReusableCellWithIdentifier("EmotionCell", forIndexPath: indexPath) as! EmotionCell
                        cell.emotionLabel.text = emotion
                        cell.selectionStyle = UITableViewCellSelectionStyle.None
                        cell.layoutMargins = UIEdgeInsetsZero
                        return cell
                    }
                }
                for (category, categoryIndex) in categoryIndexes {
                    if (indexPath.row == categoryIndex) {
                        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCell
                        cell.categoryLabel.text = category
                        cell.selectionStyle = UITableViewCellSelectionStyle.None
                        cell.layoutMargins = UIEdgeInsetsZero
                        return cell
                    }
                }
                for (opinionText, opinionTextIndex) in opinionTextIndexes {
                    if (indexPath.row == opinionTextIndex) {
                        let cell = tableView.dequeueReusableCellWithIdentifier("OpinionTextCell", forIndexPath: indexPath)
                        cell.textLabel!.text = opinionText
                        cell.selectionStyle = UITableViewCellSelectionStyle.None
                        cell.layoutMargins = UIEdgeInsetsZero
                        return cell
                    }
                }
            }
            
            cell.layoutMargins = UIEdgeInsetsZero
            
            return cell
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        let label : UILabel = UILabel()
        label.font = UIFont (name: "HelveticaNeue-Bold", size: 20)
        label.textColor = UIColor(red: 21.0/255.0, green: 124.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        if(section == 0){
            label.text = "Pros"
        } else if (section == 1){
            label.text = "Cons"
        }
        return label
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // remove bottom extra 20px space.
        return CGFloat.min
    }
    
    func showActivityIndicator() {
        activityIndicator.hidden = false;
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true;
    }
    
    func extractOpinionsInfo() {
        polaritiesTuple = [(polarity:String, polarityTuple: [(emotion: String, emotionTuple: [(category: String, opinionsText: [String])])])]()
        indexPos = 0
        indexNeg = 0
        positiveEmotionIndexes = [(emotion:String,index:Int)]()
        positiveCategoryIndexes = [(category:String,index:Int)]()
        positiveOpinionTextIndexes = [(opinionText:String, index:Int)]()
        negativeEmotionIndexes = [(emotion:String,index:Int)]()
        negativeCategoryIndexes = [(category:String, index:Int)]()
        negativeOpinionTextIndexes = [(opinionText:String, index:Int)]()
        
        if opinionsList.count > 0 {
            var polarities = [String]()
            for opinion in opinionsList {
                if !polarities.contains(opinion.polarity!) {
                    polarities.append(opinion.polarity!)
                }
            }
            
            for polarity in polarities {
                var emotions = [String]()
                for opinion in opinionsList {
                    if opinion.polarity == polarity {
                        if !emotions.contains(opinion.emotion!) {
                            emotions.append(opinion.emotion!)
                        }
                    }
                }
                print(emotions)
                
                var emotionsTuple = [(emotion: String, emotionTuple: [(category: String, opinionsText: [String])])]()
                for emotion in emotions {
                    print(emotion)
                    if (polarity == "positive") {
                        positiveEmotionIndexes.append((emotion,indexPos))
                        indexPos += 1
                    } else if (polarity == "negative") {
                        negativeEmotionIndexes.append((emotion,indexNeg))
                        indexNeg += 1
                    }
                    var categories = [String: (String, String)]()
                    for opinion in opinionsList {
                        if opinion.emotion == emotion && opinion.polarity == polarity  {
                            let key = opinion.aspect!+"#"+opinion.attribute!
                            if categories[key] == nil {
                                categories[key] = (opinion.aspect!, opinion.attribute!)
                            }
                        }
                    }
                    print(categories)
                    var categoriesTuple = [(category: String, opinionsText: [String])]()
                    for  (key, (aspect, attribute)) in categories {
                        if (polarity == "positive") {
                            positiveCategoryIndexes.append((key,indexPos))
                            indexPos += 1
                        } else if (polarity == "negative") {
                            negativeCategoryIndexes.append((key,indexNeg))
                            indexNeg += 1
                        }
                        
                        var opinionsTextArray = [String]()
                        for opinion in opinionsList {
                            if opinion.aspect! == aspect && opinion.attribute! == attribute && opinion.polarity == polarity && opinion.emotion == emotion {
                                if (polarity == "positive") {
                                    positiveOpinionTextIndexes.append((opinion.body!,indexPos))
                                    indexPos += 1
                                } else if (polarity == "negative") {
                                    negativeOpinionTextIndexes.append((opinion.body!,indexNeg))
                                    indexNeg += 1
                                }
                                
                                opinionsTextArray.append(opinion.body!)
                            }
                        }
                        print(opinionsTextArray)
                        categoriesTuple.append((category:key, opinionsText:opinionsTextArray))
                    }
                    emotionsTuple.append((emotion:emotion, emotionTuple:categoriesTuple))
                }
                polaritiesTuple.append((polarity:polarity, polarityTuple: emotionsTuple))
            }
        }
        print(positiveEmotionIndexes)
        print(positiveCategoryIndexes)
        print(positiveOpinionTextIndexes)
        print(negativeEmotionIndexes)
        print(negativeCategoryIndexes)
        print(negativeOpinionTextIndexes)
        
        self.stopActivityIndicator()
        self.addReviewTableView.hidden = false
        self.addReviewTableView.reloadData()
    }
}
