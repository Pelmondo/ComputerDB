//
//  ComputerCompanyCell.swift
//  ComputerDB
//
//  Created by Сергей Прокопьев on 16.03.2020.
//  Copyright © 2020 PelmondoProd. All rights reserved.
//

import Foundation
import UIKit


class ComputerCompanyCell: ComputerCell {
    
    //MARK: - UI Elements
        let companyLabel: UILabel = {
           let label = UILabel()
            label.numberOfLines = 0
            label.font = .italicSystemFont(ofSize: 16)
            label.text = "company name"
            label.translatesAutoresizingMaskIntoConstraints = false
           return label
        }()
    
        let computerCompanyLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = "test"
            label.font = .boldSystemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
                
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(nameLabel)
            addSubview(computerNameLabel)
            addSubview(computerCompanyLabel)
            addSubview(companyLabel)
            setUpLayout()
            setUpNewLayout()
        }
    
    private func setUpNewLayout() {
        let constraints = [
            companyLabel.topAnchor.constraint(equalTo: computerNameLabel.bottomAnchor,
                                              constant: 8),
            companyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -16),
            companyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                  constant: 16),
            //computer company name
            computerCompanyLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor),
            computerCompanyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                           constant: -16),
            computerCompanyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                          constant: 16),
            computerCompanyLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                         constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
