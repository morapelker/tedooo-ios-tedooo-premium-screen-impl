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
    
    init(hasTrial: Bool) {
        self.hasTrial = hasTrial
        self.api = DIContainer.shared.resolve(TedoooPremiumApi.self)
        self.premiumPeople = api.getPremiumPeople()
    }

    func closeTapped() {
        resultFlow.send(.cancelled)
    }
    
}
