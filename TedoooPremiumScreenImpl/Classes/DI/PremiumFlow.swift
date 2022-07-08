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
    case didSub(subUntil: Int64)
    case cancelled
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
        let vc = PremiumViewController.instantiate(hasTrial: hasTrial)
        viewController.present(vc, animated: true)
        return vc.resultFlow
    }
    
}
