//
//  ViewController.swift
//  TedoooPremiumScreenImpl
//
//  Created by morapelker on 07/07/2022.
//  Copyright (c) 2022 morapelker. All rights reserved.
//

import UIKit
import TedoooPremiumScreenImpl
import TedoooCombine

class ViewController: UIViewController {

    private var bag = CombineBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startFlowWithTrial(_ sender: Any) {
        let flow = PremiumFlow(container: DIStuff.shared.container)
        flow.launchFlow(in: self, hasTrial: true, fromOnBoarding: true).sink { result in
            switch result {
            case .cancelled:
                print("cancelled flow")
            case .didSub(subUntil: let newSubUntil):
                print("new sub until", newSubUntil)
            }
        } => bag
    }
    
    @IBAction func startFlowNoTrial(_ sender: Any) {
        let flow = PremiumFlow(container: DIStuff.shared.container)
        flow.launchFlow(in: self, hasTrial: false, fromOnBoarding: false).sink { result in
            switch result {
            case .cancelled:
                print("cancelled flow")
            case .didSub(subUntil: let newSubUntil):
                print("new sub until", newSubUntil)
            }
        } => bag
    }
    
}

