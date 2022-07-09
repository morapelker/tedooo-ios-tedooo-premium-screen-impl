//
//  DIStuff.swift
//  TedoooPremiumScreenImpl_Example
//
//  Created by Mor on 07/07/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Swinject
import TedoooPremiumApi
import Combine

class DIStuff {

    static let shared = DIStuff()
    let container = Container()
    
    init() {
        container.register(DIImplementors.self) { _ in
            return DIImplementors()
        }.inObjectScope(.container)
        container.register(TedoooPremiumApi.self) { resolver in
            return resolver.resolve(DIImplementors.self)!
        }.inObjectScope(.container)
    }
        
}

class DIImplementors: TedoooPremiumApi {
    func validateSubPermissions() -> AnyPublisher<SubInformation, SubError> {
        return Just(SubInformation.init(monthId: "monthId", yearId: "yearId", hasTrial: true)).setFailureType(to: SubError.self).eraseToAnyPublisher()
    }
    
    func registerSubInformation(_ information: SubInformation) {
        print("register", information)
    }
    
    
    func startBillingProcess(presentor: UIViewController, plan: PremiumPlan) -> AnyPublisher<BillingProcessResult, Never> {
        print("start billing process", plan)
        return Just(.success(100)).eraseToAnyPublisher()
    }
    
    func getPremiumPeople() -> AnyPublisher<[PremiumPerson], Never> {
        print("get premium people")
        return Just([
            PremiumPerson(name: "Mor", avatar: "https://i.pravatar.cc/100?a=123"),
            PremiumPerson(name: "Tal", avatar: nil),
            PremiumPerson(name: "Shachaf", avatar: "https://i.pravatar.cc/100?a=432")
        ]).eraseToAnyPublisher()
    }
    
    
    
    
}
