//
//  NetworkService.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/24/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import Foundation

protocol NetworkServiceDelegate {
    func didReceiveResponseForGetProductsList(info:NSDictionary)
    func didReceiveResponseForGetProductWithID(info:NSDictionary)
    func didReceiveResponseForGetProductReviewsWithID(info:NSDictionary)
    func didFailToReceiveResponseWithMessage(message:NSString)
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
                self.delegate!.didFailToReceiveResponseWithMessage("Response error when trying to get products list")
                print( "Reponse Error: \(error) " )
            } else {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    self.delegate!.didReceiveResponseForGetProductsList(dictionary!)
                    print( "Response: \( dictionary )" )
                } catch let jsonError as NSError {
                    // Handle parsing error
                    self.delegate!.didFailToReceiveResponseWithMessage("JSON error when trying to get products list")
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
                self.delegate!.didFailToReceiveResponseWithMessage("Response error when trying to get the product")
                print( "Reponse Error: \(error) " )
            } else {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    self.delegate!.didReceiveResponseForGetProductWithID(dictionary!)
                    print( "Response: \( dictionary )" )
                } catch let jsonError as NSError {
                    // Handle parsing error
                    self.delegate!.didFailToReceiveResponseWithMessage("JSON error when trying to get the product")
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
                self.delegate!.didFailToReceiveResponseWithMessage("Response error when trying to get the reviews")
                print( "Reponse Error: \(error) " )
            } else {
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    self.delegate!.didReceiveResponseForGetProductReviewsWithID(dictionary!)
                    print( "Response: \( dictionary )" )
                } catch let jsonError as NSError {
                    // Handle parsing error
                    self.delegate!.didFailToReceiveResponseWithMessage("JSON error when trying to get the reviews")
                    print( "JSONError: \(jsonError.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
}