//
//  PremiumFlow.swift
//  TedoooPremiumScreenImpl
//
//  Created by Mor on 07/07/2022.
//

import Foundation
import Swinject
import Combine

public enum PremiumResult {
    case didSub(_ vc: UIViewController, _ subUntil: Int64)
    case cancelled(_ vc: UIViewController)
}

public class PremiumFlow {
    
    public init(container: Container) {
        DIContainer.shared.registerContainer(container: container)
    }
    
    public func launchFlow(
        in viewController: UIViewController,
        hasTrial: Bool,
        fromOnBoarding: Bool
    ) -> AnyPublisher<PremiumResult, Never> {
        let vc = PremiumViewController.instantiate(hasTrial: hasTrial, fromOnBoarding: fromOnBoarding)
        viewController.present(vc, animated: true)
        return vc.resultFlow
    }
    
    public func launchFlow(
        inNavController navController: UINavigationController,
        hasTrial: Bool,
        fromOnBoarding: Bool
    ) -> AnyPublisher<PremiumResult, Never> {
        let vc = PremiumViewController.instantiate(hasTrial: hasTrial, fromOnBoarding: fromOnBoarding)
        navController.pushViewController(vc, animated: true)
        return vc.resultFlow
    }
}
