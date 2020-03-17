//
//  ComputerCell.swift
//  ComputerDB
//
//  Created by Сергей Прокопьев on 12.03.2020.
//  Copyright © 2020 PelmondoProd. All rights reserved.
//

import Foundation
import UIKit


class ComputerCell: UITableViewCell {
    //MARK: - UI Elements
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .italicSystemFont(ofSize: 16)
        label.text = "name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let computerNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "NAME"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLabel)
        addSubview(computerNameLabel)
        setUpLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
    
    
    func setUpLayout() {
            let constraints = [
                //nameLabel
                nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                nameLabel.bottomAnchor.constraint(equalTo: computerNameLabel.topAnchor),
                nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -16),
                nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                   constant: 16),
                //computerNameLabel
                computerNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            computerNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor,                                       constant: -8),
                computerNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                                   constant: -16),
                computerNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                                  constant: 16),
        ]
            NSLayoutConstraint.activate(constraints)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
