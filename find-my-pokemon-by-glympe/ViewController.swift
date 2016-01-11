//
//  ViewController.swift
//  find-my-pokemon-by-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 11/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        customiseMySearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    func customiseMySearchBar(){
        for subView in self.searchBar.subviews
        {
            for subsubView in subView.subviews
            {
                if let textField = subsubView as? UITextField
                {
                    textField.textColor = UIColor.whiteColor()
                    if textField.respondsToSelector(Selector("attributedPlaceholder")) {
                        
                        let attributeDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributeDict)
                        textField.textColor = UIColor.whiteColor()
                        textField.font = UIFont(name: "Helvetica Neue", size: 16)
                    }
                    
                }
            }
        }

    }

}

