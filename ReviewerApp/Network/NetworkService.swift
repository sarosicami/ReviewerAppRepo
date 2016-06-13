//
//  NetworkService.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/24/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import Foundation

@objc protocol NetworkServiceDelegate {
    optional func didReceiveResponseForGetProductsList(info:NSDictionary)
    optional func didReceiveResponseForGetProductWithID(info:NSDictionary)
    optional func didReceiveResponseForGetProductReviewsWithID(info:NSDictionary)
    optional func didReceiveResponseForGetReviewOpinionsWithID(info:NSDictionary)
    optional func didReceiveResponseForAddUserWithDict(info:NSDictionary)
    optional func didReceiveResponseForLogInWithDict(info:NSDictionary)
    optional func didFailToReceiveResponseWithMessage(message:NSString)
}

class NetworkService:NSObject {
    var delegate: NetworkServiceDelegate?
    
    override init() {
        super.init()
    }
    
    func getProductsList() {
        let url: NSURL = NSURL(string: "http://localhost:5000/reviewer/api/products")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            if error != nil {
                self.delegate!.didFailToReceiveResponseWithMessage!("Response error when trying to get products list")
                print( "Reponse Error: \(error) " )
            } else {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    self.delegate!.didReceiveResponseForGetProductsList!(dictionary!)
                } catch let jsonError as NSError {
                    // Handle parsing error
                    self.delegate!.didFailToReceiveResponseWithMessage!("JSON error when trying to get products list")
                    print( "JSONError: \(jsonError.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
    
    func getProductWithId(productID:NSInteger) {
        let productIdString = String(productID)
        let url: NSURL = NSURL(string: "http://localhost:5000/reviewer/api/product/" + productIdString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            if error != nil {
                self.delegate!.didFailToReceiveResponseWithMessage!("Response error when trying to get the product")
                print( "Reponse Error: \(error) " )
            } else {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    self.delegate!.didReceiveResponseForGetProductWithID!(dictionary!)
                    print( "Response: \( dictionary )" )
                } catch let jsonError as NSError {
                    // Handle parsing error
                    self.delegate!.didFailToReceiveResponseWithMessage!("JSON error when trying to get the product")
                    print( "JSONError: \(jsonError.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
    
    func getProductReviewsWithId(productID:NSInteger) {
        let productIdString = String(productID)
        let url: NSURL = NSURL(string: "http://localhost:5000/reviewer/api/reviews/" + productIdString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            if error != nil {
                self.delegate!.didFailToReceiveResponseWithMessage!("Response error when trying to get the reviews")
                print( "Reponse Error: \(error) " )
            } else {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    self.delegate!.didReceiveResponseForGetProductReviewsWithID!(dictionary!)
//                    print( "Response: \( dictionary )" )
                } catch let jsonError as NSError {
                    // Handle parsing error
                    self.delegate!.didFailToReceiveResponseWithMessage!("JSON error when trying to get the reviews")
                    print( "JSONError: \(jsonError.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
    
    func getReviewOpinionsWithId(reviewID:NSInteger) {
        let reviewIdString = String(reviewID)
        let url: NSURL = NSURL(string: "http://localhost:5000/reviewer/api/opinions/" + reviewIdString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            if error != nil {
                self.delegate!.didFailToReceiveResponseWithMessage!("Response error when trying to get the reviews")
                print( "Reponse Error: \(error) " )
            } else {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    self.delegate!.didReceiveResponseForGetReviewOpinionsWithID!(dictionary!)
                    //                    print( "Response: \( dictionary )" )
                } catch let jsonError as NSError {
                    // Handle parsing error
                    self.delegate!.didFailToReceiveResponseWithMessage!("JSON error when trying to get the reviews")
                    print( "JSONError: \(jsonError.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
    
    func addUserWithDict(userDict:NSDictionary) {
        let url: NSURL = NSURL(string: "http://localhost:5000/reviewer/api/users")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:url)
        urlRequest.HTTPMethod = "POST"
        
        let session = NSURLSession.sharedSession()
        
        urlRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(userDict, options:[])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            if error != nil {
                self.delegate!.didFailToReceiveResponseWithMessage!("Response error when trying to add a new user")
                print( "Reponse Error: \(error) " )
            } else {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    self.delegate!.didReceiveResponseForAddUserWithDict!(dictionary!)
                                        print( "Response: \( dictionary )" )
                } catch let jsonError as NSError {
                    // Handle parsing error
                    self.delegate!.didFailToReceiveResponseWithMessage!("JSON error when trying to add a new user")
                    print( "JSONError: \(jsonError.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
    
    func loginWithDict(userDict:NSDictionary) {
        let url: NSURL = NSURL(string: "http://localhost:5000/reviewer/api/login")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:url)
        urlRequest.HTTPMethod = "POST"
        
        let session = NSURLSession.sharedSession()
        
        urlRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(userDict, options:[])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            if error != nil {
                self.delegate!.didFailToReceiveResponseWithMessage!("Response error when trying to login")
                print( "Reponse Error: \(error) " )
            } else {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    self.delegate!.didReceiveResponseForLogInWithDict!(dictionary!)
                    print( "Response: \( dictionary )" )
                } catch let jsonError as NSError {
                    // Handle parsing error
                    self.delegate!.didFailToReceiveResponseWithMessage!("JSON error when trying to login")
                    print( "JSONError: \(jsonError.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
}
