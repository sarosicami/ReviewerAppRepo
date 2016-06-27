//
//  ReviewsSummaryViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/12/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ReviewsSummaryViewController: UIViewController, NetworkServiceDelegate {
    @IBOutlet weak var reviewsSummaryTableView: UITableView!
    
    // MARK: properties declaration
    var product = Product()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    let service = NetworkService ()
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = tabBarController  as! ReviewsTabBarController
        product = tbvc.product
        
        // remove white padding on the left side of separator lines
        reviewsSummaryTableView.layoutMargins = UIEdgeInsetsZero
        reviewsSummaryTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        reviewsSummaryTableView.tableFooterView = UIView()
        
        // configure table view to have cells with dynamic height
        reviewsSummaryTableView.rowHeight = UITableViewAutomaticDimension
        reviewsSummaryTableView.estimatedRowHeight = 21.0
        
        self.reviewsSummaryTableView.hidden = true
        service.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        // get data from server
        self.showActivityIndicator()
        service.getReviewsOpinionsWithProductId(product.id!)
    }
    
    override func viewDidAppear(animated: Bool) {
        let tbvc = tabBarController  as! ReviewsTabBarController
        tbvc.title = "Summary"
    }
    
    // MARK: Network-Service delegate methods
    func didReceiveResponseForGetReviewsOpinionsWithProductID(opinionsDict:NSDictionary) {
        print("Info dictionary:\( opinionsDict )")
        opinionsList = [Opinion]()
        
        if let opinions = opinionsDict.valueForKey("opinions") as? [NSDictionary] {
            for opinionDict in opinions {
                let opinion = Opinion(dict:opinionDict)
                opinionsList.append(opinion)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
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
    
    // MARK: TableView delegate & datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return indexPos
        } else if section == 1 {
            return indexNeg
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
        view.bringSubviewToFront(activityIndicator)
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
        self.reviewsSummaryTableView.hidden = false
        self.reviewsSummaryTableView.reloadData()
    }
}

