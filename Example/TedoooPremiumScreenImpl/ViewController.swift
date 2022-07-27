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
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .overCurrentContext
        navController.isNavigationBarHidden = true
        self.present(navController, animated: true) {
            flow.launchFlow(inNavController: navController, hasTrial: true, fromOnBoarding: true, source: "asd").sink { result in
                switch result {
                case .cancelled(let vc):
                    let newVc = UIViewController()
                    newVc.view.backgroundColor = .blue
                    vc.navigationController?.pushViewController(newVc, animated: true)
                case .didSub(let vc, let subUntil):
                    let newVc = UIViewController()
                    newVc.view.backgroundColor = .green
                    vc.navigationController?.pushViewController(newVc, animated: true)
                    print("new sub until", subUntil)
                }
            } => self.bag
        }
        
    }
    
    @IBAction func startFlowNoTrial(_ sender: Any) {
        let flow = PremiumFlow(container: DIStuff.shared.container)
        flow.launchFlow(in: self, hasTrial: false, fromOnBoarding: false, source: "asd").sink { result in
            switch result {
            case .cancelled(let vc):
                vc.dismiss(animated: true)
                print("cancelled")
            case .didSub(let vc, let subUntil):
                vc.dismiss(animated: true)
                print("new sub until", subUntil)
            }
        } => bag
    }
    
}

