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
import TedoooPremiumApi
import TedoooPremiumScreen
class PremiumViewController: UIViewController {
    
    private(set) var viewModel: PremiumViewModel!
    private var bag = CombineBag()
    
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var imgPremium1: UIImageView!
    @IBOutlet weak var imgPremium2: UIImageView!
    @IBOutlet weak var imgPremium3: UIImageView!
    @IBOutlet weak var lblPremiumUser: UILabel!
    @IBOutlet weak var btnClose: UIImageView!
    
    @IBOutlet weak var viewMonthly: UIView!
    @IBOutlet weak var viewPopular: UIView!
    
    @IBOutlet weak var viewChoosePlan: UIView!
    @IBOutlet weak var lblStrikethroughPrice: UILabel!
    @IBOutlet weak var viewYearly: UIView!
    
    @IBOutlet weak var lblJoinDescription: UITextView!
    
    @IBOutlet weak var thinaWidth: NSLayoutConstraint!
    @IBOutlet weak var thinaLeading: NSLayoutConstraint!
    @IBOutlet weak var lblEnjoyPremium2: UILabel!
    @IBOutlet weak var lblEnjoyPremium1: UILabel!
    
    
    @Inject private var api: TedoooPremiumApi
    
    static func instantiate(
        hasTrial: Bool,
        fromOnBoarding: Bool
    ) -> PremiumViewController {
        let vc = GPHelper.instantiateViewController(type: PremiumViewController.self)
        vc.viewModel = PremiumViewModel(
            hasTrial: hasTrial,
            fromOnBoarding: fromOnBoarding
        )
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
    
    var resultFlow: AnyPublisher<PremiumResult, Never> {
        viewModel.resultFlow.eraseToAnyPublisher()
    }
 
    @objc private func selectedMonthly() {
        api.startBillingProcess(presentor: self, plan: .monthly).sink { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newSubUntil):
                self.viewModel.didSub(self, newSubUntil: newSubUntil)
            case .cancelled: break
            }
        } => bag
    }
    
    @objc private func selectedYearly() {
        api.startBillingProcess(presentor: self, plan: .yearly).sink { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newSubUntil):
                self.viewModel.didSub(self, newSubUntil: newSubUntil)
            case .cancelled: break
            }
        } => bag
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewMonthly.addGestureRecognizer(target: self, selector: #selector(selectedMonthly))
        viewYearly.addGestureRecognizer(target: self, selector: #selector(selectedYearly))
        
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
        
        
        let joinDescription = NSMutableAttributedString(string: "Join Tedooo premiums squad,\nget a FREE month and a 50% discount")
        
        
        let entireRange = NSRange(location: 0, length: joinDescription.length)
        joinDescription.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: entireRange)
        joinDescription.addAttribute(.foregroundColor, value: UIColor.init(hex: "#777777"), range: entireRange)
        
        let freeMonthRange = joinDescription.mutableString.range(of: "FREE month")
        joinDescription.addAttribute(.foregroundColor, value: UIColor.black, range: freeMonthRange)
        joinDescription.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: freeMonthRange)

        let discountRange = joinDescription.mutableString.range(of: "50% discount")

        joinDescription.addAttribute(.foregroundColor, value: UIColor.black, range: discountRange)
        joinDescription.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: discountRange)
        
        lblJoinDescription.attributedText = joinDescription
        lblJoinDescription.textAlignment = .center
        
        if let begin = lblJoinDescription.position(from: lblJoinDescription.beginningOfDocument, offset: freeMonthRange.location) {
            if let end = lblJoinDescription.position(from: begin, offset: freeMonthRange.length) {
                if let textRange = lblJoinDescription.textRange(from: begin, to: end) {
                    let frame = lblJoinDescription.firstRect(for: textRange)
                    thinaLeading.constant = frame.minX + 12
                    thinaWidth.constant = frame.width
                }
                
            }
            
        }
        
        
        let enjoyPremiumAttributed = NSMutableAttributedString(string: "Enjoy all of Tedooo's premium features")
        let premiumRange = enjoyPremiumAttributed.mutableString.range(of: "premium")
        enjoyPremiumAttributed.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15), range: premiumRange)
        enjoyPremiumAttributed.addAttribute(.foregroundColor, value: UIColor.black, range: premiumRange)
        
        lblEnjoyPremium1.attributedText = enjoyPremiumAttributed
        lblEnjoyPremium2.attributedText = enjoyPremiumAttributed
        
        lblStrikethroughPrice.text = "$ 299.99"
        
        viewChoosePlan.layer.cornerRadius = 4
        
        if viewModel.fromOnBoarding {
            btnClose.isHidden = true
            btnSkip.isHidden = false
        } else {
            btnClose.addGestureRecognizer(target: self, selector: #selector(closeClicked))
            btnClose.isHidden = false
            btnSkip.isHidden = true
        }
        
        
        
        if viewModel.fromOnBoarding {
            btnBack.isHidden = false
            btnBack.addGestureRecognizer(target: self, selector: #selector(backClicked))
        } else {
            btnBack.isHidden = true
        }
        
        subscribe()
    }
    
    @objc private func backClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    private func subscribe() {
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
        self.viewModel.closeTapped(vc: self)
    }
    
}
