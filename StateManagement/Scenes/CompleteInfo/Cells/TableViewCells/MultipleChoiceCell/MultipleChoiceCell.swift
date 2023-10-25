//
//  MultipleChoiceCell.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit

class MultipleChoiceCell: UITableViewCell {

    @IBOutlet weak var tableViewAns: UITableView!
    @IBOutlet weak var lblQues: UILabel!
    @IBOutlet weak var ansHeight: NSLayoutConstraint!
    
    var didSelectAns: ((String)->Void)?
    
    var multipleChoice: MultipleChoiceVO?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewAns.dataSource = self
        tableViewAns.delegate = self
        tableViewAns.registerCell(from: MCAnsCell.self)
    }

    func bindQuestion(with data: MultipleChoiceVO) {
        lblQues.attributedText = (data.question ?? "").highlightString()
        self.multipleChoice = data
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
        ansHeight.constant = CGFloat(56 * (multipleChoice?.options?.count ?? 0))
        self.tableViewAns.reloadData()
    }
}

extension MultipleChoiceCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multipleChoice?.options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(from: MCAnsCell.self, at: indexPath)
        cell.data = multipleChoice?.options?[indexPath.row]
        return cell
    }
}

extension MultipleChoiceCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ans = multipleChoice?.options?[indexPath.row] {
            self.didSelectAns?(ans)
        }
        
    }
}
