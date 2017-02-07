//
//  ViewController.swift
//  WisdomClient
//
//  Created by Sergio Infante on 2/5/17.
//  Copyright © 2017 Sergio Infante. All rights reserved.
//

import UIKit
import Alamofire

struct Card {
    let id: Int!
    let title: String
    let isTitleVisible: Bool
    let text: String
    let secondaryText: String?
    let image: String?
    let createdBy: User
    let updatedBy: User
    let author: String
}

struct User {
    let username: String
    let firstName: String
    let lastName: String
    let isStaff: Bool
    let isActive: Bool
    let email: String
    
    static func parse(_: NSDictionary?) -> User{
        return User(username: "", firstName: "", lastName: "", isStaff: true, isActive: true, email: "")
    }
}

class ViewController: UIViewController {
    
    var cards = [Card]()
    
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
                let cardId = item["id"] as! Int
                let title = item["title"] as! String
                let text = item["text"] as! String
                let isTitleVisible = item["is_title_visible"] as! Bool
                let image = item["image"] as? String
                let secondaryText = item["secondary_text"] as? String
                let createdBy = User.parse(item["created_by"] as? NSDictionary)
                let updatedBy = User.parse(item["updated_by"] as? NSDictionary)
                let author = item["author"] as! String
                cards.append(Card.init(id: cardId, title: title, isTitleVisible: isTitleVisible, text: text, secondaryText: secondaryText, image: image, createdBy: createdBy, updatedBy: updatedBy, author: author))
                
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

