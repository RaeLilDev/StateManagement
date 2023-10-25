//
//  CompleteInfoTwoVC.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit
import RxSwift
import RxCocoa

class CompleteInfoTwoVC: UIViewController {

    @IBOutlet weak var tableViewDiet: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblDiet: UILabel!
    
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
        btnNext.layer.cornerRadius = 8.0
        lblDiet.attributedText = "Select the diets you follow. *".highlightString()
    }
    
    private func setupTableView() {
        tableViewDiet.dataSource = self
        tableViewDiet.delegate = self
        tableViewDiet.registerCell(from: DietCell.self)
        tableViewDiet.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableViewDiet.allowsMultipleSelection = true
    }
    
    
    private func bindData() {
        viewModel.selectedDietList.subscribe(onNext: {[weak self] data in
            guard let self = self else  { return }
            self.updateUI(with: data)
        }).disposed(by: disposeBag)
    }

    private func updateUI(with dietList: [DietVO]) {
        let selectionExist = !dietList.isEmpty
        btnNext.isEnabled = selectionExist
        btnNext.alpha = selectionExist ? 1.0 : 0.5
        if let diet = dietList.last, diet.name == "None" {
            deselectAllDietsExceptNone()
        } else if dietList.count > 1 {
            if let diet = dietList.first, diet.name == "None" {
                deselectNone()
            }
        }
    }
    
    private func deselectAllDietsExceptNone() {
        if let selectedIndexPaths = tableViewDiet.indexPathsForSelectedRows {
            for indexPath in selectedIndexPaths {
                if indexPath.row != 0 {
                    tableViewDiet.deselectRow(at: indexPath, animated: true)
                    viewModel.deselectDiet(by: indexPath.row)
                }
            }
        }
    }
    
    private func deselectNone() {
        if let selectedIndexPath = tableViewDiet.indexPathsForSelectedRows?.first {
            if selectedIndexPath.row == 0 {
                tableViewDiet.deselectRow(at: selectedIndexPath, animated: true)
                viewModel.deselectDiet(by: selectedIndexPath.row)
            }
        }
    }
    
    @IBAction func onTapNext(_ sender: UIButton) {
        delegate?.didChangeStep(isForward: true)
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        delegate?.didChangeStep(isForward: false)
    }
    

}

extension CompleteInfoTwoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getDietCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(from: DietCell.self, at: indexPath)
        cell.data = viewModel.getDiet(by: indexPath.row)
        return cell
    }
}

extension CompleteInfoTwoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectDiet(by: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.deselectDiet(by: indexPath.row)
    }
}
