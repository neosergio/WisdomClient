
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
    var cardPicked: Card!
    let swipeRecognizer = UISwipeGestureRecognizer()
    
    @IBOutlet weak var mainAuthor: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    typealias JSONStandar = [AnyObject]
    
    func callAlamo(url: String){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
            self.populateView()
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
    
    func swipedDetected(_ gesture: UIGestureRecognizer){
       populateView()
    }
    
    func populateView(){
        self.cardPicked = self.pickRandomCard(array: self.cards)
        self.mainAuthor.text = self.cardPicked.author
        self.mainText.text = self.cardPicked.text
        
        // Getting image from url
        let imageURL = URL(string: (self.cardPicked.image)!)
        let imageData = NSData(contentsOf: imageURL! as URL)
        self.mainImage.image = UIImage(data: imageData! as Data)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let cardsURL = "\(Constants.mainURL)cards/"
        callAlamo(url: cardsURL)
        self.mainAuthor.text = ""
        self.mainText.text = ""
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedDetected(_:)))
        swipe.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

