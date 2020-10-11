//
//  TweetViewController.swift
//  Twitter
//
//  Created by Elaine Duh on 10/10/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charCountTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display keyboard
        tweetTextView.becomeFirstResponder()
        
        tweetTextView.delegate = self
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        // If text inside, try to poost tweet
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        }
        // If no text, dismiss
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the max character limit
        let characterLimit = 280
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // Update character count label
        if (newText.count <= characterLimit) {
            charCountTextView.text = String(newText.count)
        }
        
        // Change character count label to red if at character limit
        if (newText.count < characterLimit) {
            charCountTextView.textColor = UIColor.black
        }
        else {
            charCountTextView.textColor = UIColor.red
        }
        
        // The new text should be allowed? True/False
        return newText.count <= characterLimit
    }
}
