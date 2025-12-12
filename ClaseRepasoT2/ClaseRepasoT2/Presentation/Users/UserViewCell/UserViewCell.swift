//
//  UserViewCell.swift
//  ClaseRepasoT2
//
//  Created by Brayan Munoz Campos on 11/12/25.
//

import UIKit

protocol UserViewCellDelegate: AnyObject {
    func didTapSeeDetail(user: UserModel)
    func didTapDelete(user: UserModel)
}

class UserViewCell: UITableViewCell {
    @IBOutlet weak var fullNameLabel: UILabel!
    
    weak var delegate: UserViewCellDelegate?
    private var user: UserModel?
    
    static let identifier = "UserViewCell"
    static let nibName = "UserViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
    }
    
    func buildCell(user: UserModel) {
        self.user = user
        fullNameLabel.text = user.fullName
    }
    
    @IBAction func seeButtonTapped(_ sender: Any) {
        guard let user else { return }
        delegate?.didTapSeeDetail(user: user)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let user else { return }
        delegate?.didTapDelete(user: user)
    }
}
