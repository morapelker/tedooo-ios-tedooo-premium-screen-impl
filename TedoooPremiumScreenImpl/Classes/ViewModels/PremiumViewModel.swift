//
//  PremiumViewModel.swift
//  TedoooPremiumScreenImpl
//
//  Created by Mor on 07/07/2022.
//

import Foundation
import Combine
import TedoooPremiumApi

class PremiumViewModel {
 
    let hasTrial: Bool
    let resultFlow = PassthroughSubject<PremiumResult, Never>()
    
    let premiumPeople: AnyPublisher<[PremiumPerson], Never>
    
    private let api: TedoooPremiumApi
    let fromOnBoarding: Bool
    
    init(
        hasTrial: Bool,
        fromOnBoarding: Bool
    ) {
        self.hasTrial = hasTrial
        self.fromOnBoarding = fromOnBoarding
        self.api = DIContainer.shared.resolve(TedoooPremiumApi.self)
        self.premiumPeople = api.getPremiumPeople()
    }

    func closeTapped(vc: UIViewController) {
        resultFlow.send(.cancelled(vc))
        resultFlow.send(completion: .finished)
    }
    
    func didSub(_ vc: UIViewController, newSubUntil: Int64) {
        resultFlow.send(.didSub(vc, newSubUntil))
        resultFlow.send(completion: .finished)
    }
}
