//
//  PremiumFlow.swift
//  TedoooPremiumScreenImpl
//
//  Created by Mor on 07/07/2022.
//

import Foundation
import Swinject
import Combine
import TedoooPremiumScreen
import UIKit


public class PremiumFlow: TedoooPremiumScreen {
    
    public init(container: Container) {
        DIContainer.shared.registerContainer(container: container)
    }
    
    public func launchFlow(
        in viewController: UIViewController,
        hasTrial: Bool,
        fromOnBoarding: Bool,
        source: String
    ) -> AnyPublisher<PremiumResult, Never> {
        let vc = PremiumViewController.instantiate(
            hasTrial: hasTrial,
            fromOnBoarding: fromOnBoarding,
            source: source
        )
        viewController.present(vc, animated: true)
        return vc.resultFlow
    }
    
    public func launchFlow(
        inNavController navController: UINavigationController,
        hasTrial: Bool,
        fromOnBoarding: Bool,
        source: String
    ) -> AnyPublisher<PremiumResult, Never> {
        let vc = PremiumViewController.instantiate(
            hasTrial: hasTrial,
            fromOnBoarding: fromOnBoarding,
            source: source
        )
        navController.pushViewController(vc, animated: true)
        return vc.resultFlow
    }
}
