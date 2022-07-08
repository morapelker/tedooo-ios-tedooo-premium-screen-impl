//
//  PremiumViewController.swift
//  TedoooPremiumScreenImpl
//
//  Created by Mor on 07/07/2022.
//

import Foundation
import UIKit
import Combine
import TedoooCombine
import TedoooStyling
import Kingfisher
class PremiumViewController: UIViewController {
    
    private(set) var viewModel: PremiumViewModel!
    private var bag = CombineBag()
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var imgPremium1: UIImageView!
    @IBOutlet weak var imgPremium2: UIImageView!
    @IBOutlet weak var imgPremium3: UIImageView!
    @IBOutlet weak var lblPremiumUser: UILabel!
    @IBOutlet weak var btnClose: UIImageView!
    
    @IBOutlet weak var viewFree: UIView!
    @IBOutlet weak var viewMonthly: UIView!
    @IBOutlet weak var viewPopular: UIView!
    
    @IBOutlet weak var viewChoosePlan: UIView!
    @IBOutlet weak var lblStrikethroughPrice: UILabel!
    @IBOutlet weak var viewYearly: UIView!
    
    @IBOutlet weak var lblJoinDescription: UILabel!
    
    @IBOutlet weak var lblEnjoyPremium2: UILabel!
    @IBOutlet weak var lblEnjoyPremium1: UILabel!
    
    static func instantiate(hasTrial: Bool) -> PremiumViewController {
        let vc = GPHelper.instantiateViewController(type: PremiumViewController.self)
        vc.viewModel = PremiumViewModel(hasTrial: hasTrial)
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
    
    var resultFlow: AnyPublisher<PremiumResult, Never> {
        viewModel.resultFlow.eraseToAnyPublisher()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Styling.styleShadowView(viewFree, cornerRadius: 8, shadowOffset: .init(width: 0, height: 3), shadowRadius: 10.66, shadowOpacity: 1, shadowColor: .init(red: 0.508, green: 0.508, blue: 0.508, alpha: 0.5))
        
        viewMonthly.layer.cornerRadius = 8
        viewMonthly.layer.borderWidth = 2
        viewMonthly.layer.borderColor = UIColor.init(hex: "#2673FF").cgColor
        
        viewPopular.layer.cornerRadius = 8
        viewPopular.backgroundColor = UIColor.init(hex: "#2673FF")
        
        viewYearly.layer.cornerRadius = 8
        viewYearly.layer.borderWidth = 2
        viewYearly.layer.borderColor = UIColor.init(hex: "#F3D35F").cgColor
        
        imgPremium1.layer.cornerRadius = 16
        imgPremium2.layer.cornerRadius = 16
        imgPremium3.layer.cornerRadius = 16
        
        lblJoinDescription.textColor = UIColor.darkGray
        let joinDescription = NSMutableAttributedString(string: "Join Tedooo premiums squad,\nget a FREE month and a 50% discount")
        let range = joinDescription.mutableString.range(of: "FREE month")
        joinDescription.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        joinDescription.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: range)
        
        let discountRange = joinDescription.mutableString.range(of: "50% discount")
        
        joinDescription.addAttribute(.foregroundColor, value: UIColor.black, range: discountRange)
        joinDescription.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: discountRange)
        
        lblJoinDescription.attributedText = joinDescription
        
        let enjoyPremiumAttributed = NSMutableAttributedString(string: "Enjoy all of Tedooo's premium features")
        let premiumRange = enjoyPremiumAttributed.mutableString.range(of: "premium")
        enjoyPremiumAttributed.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 12), range: premiumRange)
        enjoyPremiumAttributed.addAttribute(.foregroundColor, value: UIColor.black, range: premiumRange)
        
        lblEnjoyPremium1.attributedText = enjoyPremiumAttributed
        lblEnjoyPremium2.attributedText = enjoyPremiumAttributed
        
        let strikethroughText = NSMutableAttributedString(string: "$ 299.99")
        strikethroughText.addAttribute(.strikethroughStyle, value: 1, range: NSRange(location: 0, length: strikethroughText.length))
        lblStrikethroughPrice.attributedText = strikethroughText
        
        viewChoosePlan.layer.cornerRadius = 4
        
        btnClose.addGestureRecognizer(target: self, selector: #selector(closeClicked))
        
        subscribe()
    }
    
    private func subscribe() {
        viewModel.resultFlow.sink { [weak self] _ in
            self?.dismiss(animated: true)
        } => bag
        viewModel.premiumPeople.map({$0.shuffled()}).sink { [weak self] people in
            guard let self = self else { return }
            for (offset, person) in people.enumerated() {
                if let avatar = person.avatar, let url = URL(string: avatar) {
                    switch offset {
                    case 0:
                        self.imgPremium1.kf.setImage(with: url)
                    case 1:
                        self.imgPremium2.kf.setImage(with: url)
                    default:
                        self.imgPremium3.kf.setImage(with: url)
                    }
                } else {
                    switch offset {
                    case 0:
                        self.imgPremium1.image = UIImage(named: "user_placeholder")
                    case 1:
                        self.imgPremium2.image = UIImage(named: "user_placeholder")
                    default:
                        self.imgPremium3.image = UIImage(named: "user_placeholder")
                    }
                }
            }
            self.lblPremiumUser.text = String(format: NSLocalizedString("%@ and more from your industry are using Premium!", comment: ""), people.first?.name ?? "")
            
        } => bag
    }
    
    @IBAction func closeClicked() {
        self.viewModel.closeTapped()
    }
    
}
