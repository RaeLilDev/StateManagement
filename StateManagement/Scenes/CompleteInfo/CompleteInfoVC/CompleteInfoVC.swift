//
//  CompleteInfoVC.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit
import RxSwift
import RxCocoa

class CompleteInfoVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var viewModel: CompleteInfoViewModel!
    private let disposeBag = DisposeBag()
    
    private var pageView: UIPageViewController?
    private var pages: [UIViewController] = []
    private var direction: UIPageViewController.NavigationDirection = .forward
    
    private var currentStep: Int? {
        didSet {
            pageDidChange()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchAllData()
        
        bindData()
    }
    
    
    private func bindData() {
        Observable.combineLatest(viewModel.healthConcernList, viewModel.allergyList, viewModel.dietList)
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] healthList, allergyList, dietList in
                guard let self = self else { return }
                if !healthList.isEmpty && !allergyList.isEmpty && !dietList.isEmpty {
                    self.setupView()
                }
            }.disposed(by: disposeBag)
    }
    
    private func setupView() {
        progressBar.layer.cornerRadius = 8
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 8
        progressBar.subviews[1].clipsToBounds = true
        
        setupPageView()
        
        let cInfoOne = CompleteInfoOneVC()
        cInfoOne.viewModel = viewModel
        cInfoOne.delegate = self
        
        let cInfoTwo = CompleteInfoTwoVC()
        cInfoTwo.viewModel = viewModel
        cInfoTwo.delegate = self
        
        let cInfoThree = CompleteInfoThreeVC()
        cInfoThree.viewModel = viewModel
        cInfoThree.delegate = self
        
        let cInfoFour = CompleteInfoFourVC()
        cInfoFour.viewModel = viewModel
        cInfoFour.delegate = self
        
        pages = [cInfoOne, cInfoTwo, cInfoThree, cInfoFour]
        
        currentStep = 1
    }
    
    private func setupPageView() {
        let pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        pageView.dataSource = self
        pageView.delegate = self
        pageView.isPagingEnabled = false
        pageView.view.frame = self.containerView.bounds
        pageView.didMove(toParent: self)
        self.pageView = pageView
        self.addChild(pageView)
        self.containerView.insertSubview(pageView.view, at: 0)
    }
    
    private func pageDidChange() {
        
        if let step = currentStep {
            
            progressBar.progress = Float(step) / 4.0
            
            pageView?.setViewControllers([pages[step - 1]], direction: direction, animated: true)
        }
        
    }
}


extension CompleteInfoVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return pages[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController) ?? 0
        if currentIndex >= pages.count - 1 {
            return nil
        }
        return pages[currentIndex + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentIndex = pageViewController.viewControllers!.first!.view.tag
        currentStep = currentIndex + 1
    }

}

extension CompleteInfoVC: CompleteInfoDelegate {
    
    func didChangeStep(isForward: Bool) {
        if let step = currentStep {
            direction = isForward ? .forward : .reverse
            currentStep = isForward ? step + 1 : step - 1
        }
    }
    
    func didTapFinish() {
        viewModel.submitData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
