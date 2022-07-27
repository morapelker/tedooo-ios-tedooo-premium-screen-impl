//
//  PremiumViewModel.swift
//  TedoooPremiumScreenImpl
//
//  Created by Mor on 07/07/2022.
//

import Foundation
import Combine
import TedoooPremiumApi
import TedoooPremiumScreen
import TedoooCombine
import TedoooAnalytics

class PremiumViewModel {
 
    let hasTrial: Bool
    let resultFlow = PassthroughSubject<PremiumResult, Never>()
    
    let premiumPeople: AnyPublisher<[PremiumPerson], Never>
    
    private let api: TedoooPremiumApi
    private let analytics: TedoooAnalytics
    
    let fromOnBoarding: Bool
    let hasSubError = PassthroughSubject<SubError, Never>()
    private var bag = CombineBag()
    private let source: String
    
    init(
        hasTrial: Bool,
        fromOnBoarding: Bool,
        source: String
    ) {
        self.hasTrial = hasTrial
        self.source = source
        self.fromOnBoarding = fromOnBoarding
        
        self.api = DIContainer.shared.resolve(TedoooPremiumApi.self)
        self.analytics = DIContainer.shared.resolve(TedoooAnalytics.self)
        
        self.premiumPeople = api.getPremiumPeople()
        self.fetchInformation()
    }

    private func fetchInformation() {
        api.validateSubPermissions().sink { [weak self] result in
            switch result {
            case .failure(let err):
                self?.hasSubError.send(err)
            case .finished: break
            }
        } receiveValue: { [weak self] information in
            self?.api.registerSubInformation(information)
        } => bag

    }
    
    func closeTapped(vc: UIViewController) {
        resultFlow.send(.cancelled(vc))
        resultFlow.send(completion: .finished)
    }
    
    func didSub(_ vc: UIViewController, newSubUntil: Int64) {
        analytics.logEvent("didSub", payload: ["source": source])
        resultFlow.send(.didSub(vc, newSubUntil))
        resultFlow.send(completion: .finished)
    }
}
