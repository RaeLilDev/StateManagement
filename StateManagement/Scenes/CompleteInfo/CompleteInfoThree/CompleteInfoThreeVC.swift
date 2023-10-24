//
//  CompleteInfoThreeVC.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit
import SearchTextField
import RxSwift
import RxCocoa

class CompleteInfoThreeVC: UIViewController {

    @IBOutlet weak var collectionViewAllergy: UICollectionView!
    @IBOutlet weak var heightAllergy: NSLayoutConstraint!
    
    @IBOutlet weak var txtFieldSearch: SearchTextField!
    @IBOutlet weak var btnNext: UIButton!
    
    var viewModel: CompleteInfoViewModel!
    weak var delegate: CompleteInfoDelegate?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupCollectionView()
        setupTxtField()
        bindData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            let allergyHeight: CGFloat = self.collectionViewAllergy.collectionViewLayout.collectionViewContentSize.height
            self.heightAllergy.constant = allergyHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupView() {
        btnNext.layer.cornerRadius = 8.0
    }
    
    private func setupCollectionView() {
        collectionViewAllergy.dataSource = self
        collectionViewAllergy.delegate = self
        collectionViewAllergy.registerCell(from: HealthConcernCell.self)
        collectionViewAllergy.allowsMultipleSelection = true
        collectionViewAllergy.isUserInteractionEnabled = false
        let layout = UICollectionViewLeftLayout()
        layout.spacing = 10.0
        collectionViewAllergy.collectionViewLayout = layout
    }
    
    private func setupTxtField() {
        txtFieldSearch.filterStrings(viewModel.getAllergyStrList())
        txtFieldSearch.itemSelectionHandler = { [weak self] filteredResults, itemPosition in
            guard let self = self else { return }
            let item = filteredResults[itemPosition]
            self.txtFieldSearch.text = ""
            self.viewModel.selectAllergy(by: item.title)
        }
    }
    
    private func bindData() {
        viewModel.selectedAllergyList.subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.collectionViewAllergy.reloadData()
        }).disposed(by: disposeBag)
    }

    @IBAction func onTapNext(_ sender: UIButton) {
        delegate?.didChangeStep(isForward: true)
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        delegate?.didChangeStep(isForward: false)
    }
}


extension CompleteInfoThreeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSelectedAllergyCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(from: HealthConcernCell.self, at: indexPath)
        cell.allergy = viewModel.getSelectedAllergy(by: indexPath.row)
        return cell
    }
    
    
}

extension CompleteInfoThreeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font =  UIFont.systemFont(ofSize: 16, weight: .medium)
        let text = viewModel.getSelectedAllergy(by: indexPath.row).name ?? ""
        let txtWidth = (text.size(withAttributes: [NSAttributedString.Key.font : font]).width)
        let width = (txtWidth + 40)
        return CGSize(width: Int(width), height: 40)
    }
}
