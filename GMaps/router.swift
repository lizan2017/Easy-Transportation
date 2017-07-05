//
//  router.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 7/5/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import Foundation

class Router{
    func pushLoginViewController(source:UIViewController, email:String){
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let loginVc = sb.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        loginVc.email = email
        source.present(loginVc, animated: true, completion: nil)
    }
}
