
//
//  ViewController.swift
//  WisdomClient
//
//  Created by Sergio Infante on 2/5/17.
//  Copyright © 2017 Sergio Infante. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var cards = [Card]()
    var cardPicked: Card!
    let swipeRecognizer = UISwipeGestureRecognizer()
    var activityBoxView = UIView()
    let picker = UIImagePickerController()
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var mainAuthor: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainToolbar: UIToolbar!
    
    typealias JSONStandar = [AnyObject]
    
    func callAlamo(url: String){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success( _):
                self.parseData(JSONData: response.data!)
                self.populateView()
                self.infoButton.isHidden = false
                self.mainToolbar.isHidden = false
                self.view.isUserInteractionEnabled = true
                // Remove activity indicator
                self.activityBoxView.removeFromSuperview()
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
        self.mainImage.image = nil
        
        // Getting image from url
        if self.cardPicked.image != nil{
            let session = URLSession(configuration: .default)
            let imageURL = URL(string: (self.cardPicked.image!))
            let downloadPicTask = session.dataTask(with: imageURL!) { (data, response, error) in
                if let e = error {
                    print("Error downloading image: \(e)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded picture with reponse code \(res.statusCode)")
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                UIView.transition(with: self.mainImage, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                                    self.mainImage.image = image
                                }, completion: nil)
                            }
                        } else {
                            print("couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
                
            }
            downloadPicTask.resume()
        }
    }
    
    func addDownloadDataView() {
        self.view.isUserInteractionEnabled = false
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
    
    func infoButtonPressed() {
        print("presed")
    }
    
    func noCamera() {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func shootPhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func shareThis(_ sender: UIBarButtonItem) {
        // text to share
        let text = "\(self.mainText.text!) --\(self.mainAuthor.text!) via @GeekyWisdom"
        
        // set up activity controller
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        addDownloadDataView()
        // Do any additional setup after loading the view, typically from a nib.
        let cardsURL = "\(Constants.mainURL)cards/"
        callAlamo(url: cardsURL)
        self.infoButton.isHidden = true
        self.mainToolbar.isHidden = true
        self.mainAuthor.text = ""
        self.mainText.text = ""
        
        // This is for swipe gesture
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedDetected(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedDetected(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        // Add info button
        //let infoButton = UIButton(type: UIButtonType.infoDark)
        //infoButton.frame = CGRect(x: view.frame.maxX - 30, y: 30, width: 16, height: 16)
        //infoButton.addTarget(self, action: #selector(infoButtonPressed), for: UIControlEvents.touchUpInside)
        //self.view.addSubview(infoButton)
        
        
        // This is for tap gesture
        // let tap = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        // self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegates
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        mainImage.contentMode = .scaleToFill
        mainImage.alpha = 0.4
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainImage.image = chosenImage
        } else if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            mainImage.image = chosenImage
        } else {
            print("something is wrong with image")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

