//
//  CompleteInfoOneVC.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit
import RxSwift
import RxCocoa

class CompleteInfoOneVC: UIViewController {

    @IBOutlet weak var collectionViewHealthConcern: UICollectionView!
    @IBOutlet weak var tableViewPrioritize: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var heightHealthConcern: NSLayoutConstraint!
    @IBOutlet weak var heightPrioritize: NSLayoutConstraint!
    @IBOutlet weak var lblHealthConcern: UILabel!
    @IBOutlet weak var lblPrioritize: UILabel!
    
    var viewModel: CompleteInfoViewModel!
    
    weak var delegate: CompleteInfoDelegate?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupCollectionView()
        
        setupTableview()
        
        bindData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            let healthHeight: CGFloat = self.collectionViewHealthConcern.collectionViewLayout.collectionViewContentSize.height
            self.heightHealthConcern.constant = healthHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupView() {
        btnNext.layer.cornerRadius = 8.0
        lblHealthConcern.attributedText = "Select the top health concerns.* (Up to 5)".highlightString()
        lblPrioritize.attributedText = "Prioritize".highlightString()
    }
    
    private func setupCollectionView() {
        collectionViewHealthConcern.dataSource = self
        collectionViewHealthConcern.delegate = self
        collectionViewHealthConcern.registerCell(from: HealthConcernCell.self)
        collectionViewHealthConcern.allowsMultipleSelection = true
        
        let layout = UICollectionViewLeftLayout()
        layout.spacing = 10.0
        collectionViewHealthConcern.collectionViewLayout = layout
    }
    
    private func setupTableview() {
        tableViewPrioritize.dataSource = self
        tableViewPrioritize.delegate = self
        tableViewPrioritize.isEditing = true
        tableViewPrioritize.registerCell(from: HealthPrioritizeCell.self)
    }
    
    private func bindData() {
        viewModel.selectedConcernList.subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.updateUI(with: data)
        }).disposed(by: disposeBag)
    }
    
    private func updateUI(with selectedList: [HealthConcernVO]) {
        let dataExist = !selectedList.isEmpty
        let moreChance = selectedList.count <= 5
        btnNext.isEnabled = dataExist && moreChance
        btnNext.alpha = (dataExist && moreChance) ? 1.0 : 0.5
        updateTableView()
    }
    
    private func updateTableView() {
        heightPrioritize.constant = CGFloat(64 * viewModel.getSelectedHealthCount())
        self.tableViewPrioritize.reloadData()
    }
    
    @IBAction func onTapNext(_ sender: UIButton) {
        delegate?.didChangeStep(isForward: true)
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        delegate?.popToRoot()
    }
}

extension CompleteInfoOneVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getHealthConcernCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(from: HealthConcernCell.self, at: indexPath)
        cell.data = viewModel.getHealthConcern(by: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectHealthConcern(by: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.deselectHealthConcern(by: indexPath.row)
    }
}

extension CompleteInfoOneVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font =  UIFont.systemFont(ofSize: 16, weight: .medium)
        let text = viewModel.getHealthConcern(by: indexPath.row).name ?? ""
        let txtWidth = (text.size(withAttributes: [NSAttributedString.Key.font : font]).width)
        let width = (txtWidth + 40)
        return CGSize(width: Int(width), height: 40)
    }
}

extension CompleteInfoOneVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSelectedHealthCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(from: HealthPrioritizeCell.self, at: indexPath)
        cell.data = viewModel.getSelectedHealth(by: indexPath.row)
        return cell
    }
    
}

extension CompleteInfoOneVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.swapRows(sourceIndex: sourceIndexPath.row, destIndex: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}
