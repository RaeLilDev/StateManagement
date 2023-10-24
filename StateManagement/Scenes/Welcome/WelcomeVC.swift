//
//  WelcomeVC.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var btnGetStarted: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        btnGetStarted.layer.cornerRadius = 8.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @IBAction func onTapGetStarted() {
        let vc = CompleteInfoVC()
        vc.viewModel = CompleteInfoViewModel(infoModel: InfoModelImpl.shared)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension WelcomeVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let controllers = self.navigationController?.viewControllers ?? []
        return controllers.count > 1
    }
}
