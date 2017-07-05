//
//  UIViewControllerExtension.swift
//  EKTracking
//
//  Created by Debashree on 4/3/17.
//  Copyright © 2017 Debashree. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

struct Associate {                                                                                                                                                                                                                                                                                                                                                                 
    static var hud: UInt8 = 0
}

extension UIViewController {

    private func setProgressHud() -> MBProgressHUD {

        let progressHud:  MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        progressHud.tintColor = UIColor.darkGray
        progressHud.removeFromSuperViewOnHide = true
        objc_setAssociatedObject(self, &Associate.hud, progressHud, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return progressHud
    }

    private var progressHud: MBProgressHUD {
        if let progressHud = objc_getAssociatedObject(self, &Associate.hud) as? MBProgressHUD {
            return progressHud
        }
        return setProgressHud()
    }

    func showProgressHud() {
        self.progressHud.show(animated: false)
    }

    func dismissProgressHud() {
        self.progressHud.completionBlock = {
            objc_setAssociatedObject(self, &Associate.hud, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        self.progressHud.hide(animated: false)
    }

    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }



}

