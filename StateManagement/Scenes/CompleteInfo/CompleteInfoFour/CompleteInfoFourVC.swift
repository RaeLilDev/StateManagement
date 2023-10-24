//
//  CompleteInfoFourVC.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit
import RxSwift
import RxCocoa

class CompleteInfoFourVC: UIViewController {

    @IBOutlet weak var tableViewMC: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var viewModel: CompleteInfoViewModel!
    
    weak var delegate: CompleteInfoDelegate?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        bindData()
    }
    
    private func setupView() {
        btnSubmit.layer.cornerRadius = 8.0
    }
    
    private func setupTableView() {
        tableViewMC.dataSource = self
        tableViewMC.registerCell(from: MultipleChoiceCell.self)
    }
    
    private func bindData() {
        Observable.combineLatest(viewModel.dailyExposure, viewModel.isSmoke, viewModel.alcohol).subscribe{ [weak self] dailyExposure, isSmoke, alcohol in
            guard let self = self else {return}
            let isValid = !(dailyExposure ?? "").isEmpty && !(isSmoke ?? "").isEmpty && !(alcohol ?? "").isEmpty
            btnSubmit.isEnabled = isValid
            btnSubmit.alpha = isValid ? 1.0 : 0.5
        }.disposed(by: disposeBag)
    }
    
    @IBAction func onTapSubmit() {
        delegate?.didTapFinish()
    }

}

extension CompleteInfoFourVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getMultipleChoiceCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(from: MultipleChoiceCell.self, at: indexPath)
        cell.bindQuestion(with: viewModel.getMultipleChoice(by: indexPath.row))
        cell.didSelectAns = {[weak self] ans in
            guard let self = self else { return }
            self.viewModel.selectMCAns(for: indexPath.row, with: ans)
        }
        return cell
    }
}
