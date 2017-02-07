//
//  ViewController.swift
//  WisdomClient
//
//  Created by Sergio Infante on 2/5/17.
//  Copyright © 2017 Sergio Infante. All rights reserved.
//

import UIKit
import Alamofire

struct card {
    let id: Int!
    let title: String!
    let is_title_visible: Bool!
    let text: String!
}

class ViewController: UIViewController {
    
    var cards = [card]()
    
    typealias JSONStandar = [AnyObject]
    
    func callAlamo(url: String){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
            let cardPicked = self.pickRandomCard(array: self.cards)
            print(cardPicked)
        })
    }

    func parseData(JSONData: Data){
        do{
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandar
            let items = readableJSON
            for i in 0..<items.count{
                let item = items[i]
                let card_id = item["id"] as! Int
                let title = item["title"] as! String
                let text = item["text"] as! String
                let is_title_visible = item["is_title_visible"] as! Bool
                cards.append(card.init(id: card_id, title: title, is_title_visible: is_title_visible, text: text))
            }
        } catch {
            print(error)
        }
    }
    
    func pickRandomCard(array: Array<Any>) -> AnyObject {
        let randomNumber = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomNumber] as AnyObject
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

