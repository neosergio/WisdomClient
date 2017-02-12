
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
    var activityBoxView = UIView()
    
    @IBOutlet weak var mainAuthor: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    typealias JSONStandar = [AnyObject]
    
    func callAlamo(url: String){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success( _):
                self.parseData(JSONData: response.data!)
                self.populateView()
            case .failure(let error):
                let alertController = UIAlertController(title: "Error", message: "Can't get information, please reopen application", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                print(error)
            }

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
    
    func tapDetected(_ gesture: UIGestureRecognizer){
        populateView()
    }
    
    func populateView(){
        self.cardPicked = self.pickRandomCard(array: self.cards)
        self.mainAuthor.text = self.cardPicked.author
        self.mainText.text = self.cardPicked.text
        
        // Getting image from url
        if self.cardPicked.image != nil {
            let imageURL = URL(string: (self.cardPicked.image!))
            let imageData = NSData(contentsOf: imageURL! as URL)
            self.mainImage.image = UIImage(data: imageData! as Data)
        } else {
            self.mainImage.image = nil
        }
        
        // Remove activity indicator
        self.activityBoxView.removeFromSuperview()
        
        
    }
    
    func addDownloadDataView() {
        activityBoxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 175, height: 35))
        activityBoxView.alpha = 0.8
        activityBoxView.layer.cornerRadius = 10
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityView.frame = CGRect(x: 135, y: -10, width: 50, height: 50)
        activityView.color = UIColor.black
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        textLabel.textColor = UIColor.black
        textLabel.font = UIFont(name: textLabel.font.fontName, size: 13)
        textLabel.text = "Checking for Update..."
        
        activityBoxView.addSubview(activityView)
        activityBoxView.addSubview(textLabel)
        
        view.addSubview(activityBoxView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDownloadDataView()
        // Do any additional setup after loading the view, typically from a nib.
        let cardsURL = "\(Constants.mainURL)cards/"
        callAlamo(url: cardsURL)
        self.mainAuthor.text = ""
        self.mainText.text = ""
        
        // This is for swipe gesture
        //let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedDetected(_:)))
        //swipe.direction = UISwipeGestureRecognizerDirection.down
        //self.view.addGestureRecognizer(swipe)
        
        // This is for tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

