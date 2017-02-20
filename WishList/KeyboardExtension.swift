//
//  KeyboardExtension.swift
//  WishList
//
//  Created by Nishant Sood on 2/20/17.
//  Copyright © 2017 Nishant Sood. All rights reserved.
//

import UIKit

extension UIViewController{

    func hideKeyboardWhenTappedAround(){
    
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard(){
    
        view.endEditing(true)
    }
}
