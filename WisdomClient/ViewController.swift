//
//  ViewController.swift
//  WisdomClient
//
//  Created by Sergio Infante on 2/5/17.
//  Copyright © 2017 Sergio Infante. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var cards = [Card]()
    
    typealias JSONStandar = [AnyObject]
    
    func callAlamo(url: String){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
            let cardPicked = self.pickRandomCard(array: self.cards)
            print(cardPicked.createdBy.email)
        })
    }

    func parseData(JSONData: Data){
        do{
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandar
            let items = readableJSON
            for i in 0..<items.count{
                let item = items[i]
                let cardObject = Card.parse(dictionary: item as! NSDictionary)
                cards.append(cardObject)
                
            }
        } catch {
            print(error)
        }
    }
    
    func pickRandomCard(array: Array<Card>) -> Card {
        let randomNumber = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomNumber]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let cardsURL = "\(Constants.mainURL)cards/"
        print(cardsURL)
        callAlamo(url: cardsURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

