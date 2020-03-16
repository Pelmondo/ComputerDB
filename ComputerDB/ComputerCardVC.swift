//
//  ComputerCardVC.swift
//  ComputerDB
//
//  Created by Сергей Прокопьев on 15.03.2020.
//  Copyright © 2020 PelmondoProd. All rights reserved.
//

import Foundation
import UIKit


class ComputerCardVC: UIViewController, ComputersGet {
    
    //MARK: - UI Elements
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "You must be looking"
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let activityInd : UIActivityIndicatorView = {
         let active = UIActivityIndicatorView()
         active.color = .black
         active.backgroundColor = .white
         active.translatesAutoresizingMaskIntoConstraints = false
         return active
     }()
    
    let computerImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name:"
        label.font = .italicSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let computerNameLabel: UILabel = {
         let label = UILabel()
         label.text = ""
         label.font = .boldSystemFont(ofSize: 20)
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    let introDateLabel: UILabel = {
            let label = UILabel()
            label.text = "introduced date:"
            label.font = .italicSystemFont(ofSize: 16)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    let computerIntroDateLabel: UILabel = {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 20)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    let discontDateLabel: UILabel = {
            let label = UILabel()
            label.text = "discontinued date:"
            label.font = .italicSystemFont(ofSize: 16)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    
    let computerDiscountLabel: UILabel = {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 20)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    let discriptionLabel: UILabel = {
            let label = UILabel()
            label.text = "discription:"
            label.font = .italicSystemFont(ofSize: 16)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    let computerDiscriptLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // buttons
    let extendButton: UIButton = {
        let button = UIButton()
        button.setTitle("tap to extand", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private func getLinkButton(_ title: String, id tag: Int, _ number: Int) {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(linkButtonTap(sender:)), for: .touchUpInside)
        button.tag = tag
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(button)
        }
    
    
    
    //MARK: - button's actions
    private var isButtonPressed = false
    @objc func tapButton(sender: UIButton) {
        computerDiscriptLabel.numberOfLines = isButtonPressed ? 3 : .max
        extendButton.setTitle(isButtonPressed ? "tap to extend" : "tap to zip", for: .normal)
        isButtonPressed = isButtonPressed ? false : true
    }
    
    @objc func linkButtonTap(sender: UIButton) {
        let nextVC = ComputerCardVC()
        nextVC.navigationItem.title = sender.title(for: .normal)
        nextVC.computerId = sender.tag
        navigationController?.pushViewController(nextVC, animated: true)
        }
    
    
    let appDelegate = AppDelegate()
    var computerId = 0
    private var isComputerCard = true
    private var similarComputer = [Items]()
    private var computerCard : ComputerCard?
    private var maxCountLink = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(computerImage)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(computerNameLabel)
        scrollView.addSubview(introDateLabel)
        scrollView.addSubview(computerIntroDateLabel)
        scrollView.addSubview(discontDateLabel)
        scrollView.addSubview(discriptionLabel)
        scrollView.addSubview(computerDiscountLabel)
        scrollView.addSubview(computerDiscriptLabel)
        scrollView.addSubview(extendButton)
        scrollView.addSubview(activityInd)
        scrollView.addSubview(previewLabel)
        scrollView.addSubview(stackView)
        activityInd.isHidden = false
        activityInd.startAnimating()
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.network.delegate = self
        appDelegate.network.getUrlForCard(computerId)
    }
    
    //MARK: - Date parse
    private let dateFormatter = DateFormatter()
    private func dateParse(_ date: String?) -> String {
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let stringDate = date else {return "-"}
        let date = dateFormatter.date(from: stringDate)
        dateFormatter.dateFormat = "dd MMM yyyy"
        guard let myDate = date else {return "-"}
        return dateFormatter.string(from: myDate)
    }
    
    //MARK: - data get
    
    private func setPlaceholder() {
        DispatchQueue.main.async {
            self.activityInd.stopAnimating()
            self.computerImage.image = #imageLiteral(resourceName: "placeholder")
        }
    }
    
    private func getImage() {
        if let stringUrl = computerCard?.imageUrl {
            guard let url = URL(string: stringUrl) else {return}
            let queue = DispatchQueue.global(qos: .utility)
            queue.async{
                do {
                    let data = try Data(contentsOf: url)
                     DispatchQueue.main.async {
                        self.computerImage.image = UIImage(data: data)
                        self.activityInd.stopAnimating()
                    }
                } catch {
                    self.setPlaceholder()
                }
            }
        } else {
            setPlaceholder()
        }
    }
    
    func getComputers(computers: Data) {
        do {
            switch isComputerCard {
            case true :
                let computer = try
                    JSONDecoder().decode(ComputerCard.self, from: computers)
                    computerCard = computer
                    appDelegate.network.getUrlSimilar(computerId)
                    isComputerCard = false
            case false :
                isComputerCard = true
                let computersLink = try
                    JSONDecoder().decode([Items].self, from: computers)
                similarComputer = computersLink
                DispatchQueue.main.async {
                    for (index, comp) in self.similarComputer.enumerated() {
                        if self.maxCountLink != 5 {
                        self.maxCountLink += 1
                        self.getLinkButton(comp.name, id: comp.id, index)
                        }
                      }
                   }
                 }
                } catch {
                    print(error)
                }
        // get Image
        getImage()
        
        DispatchQueue.main.async {
            self.computerNameLabel.text = self.computerCard?.name
            self.computerIntroDateLabel.text = self.dateParse(self.computerCard?.introduced)
            self.computerDiscountLabel.text = self.dateParse(self.computerCard?.discounted)
            self.computerDiscriptLabel.text = self.computerCard?.description
        }
        
    }
    
}


//MARK: - Layout settings
extension ComputerCardVC {

        fileprivate func setUpLayout() {
            let constraints = [
                
                view.topAnchor.constraint(equalTo: scrollView.topAnchor),
                view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                
                
                //imageView Layout
                computerImage.topAnchor.constraint(equalTo: scrollView.topAnchor,
                                                   constant: 8),
                computerImage.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: 64),
                computerImage.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -64),
                computerImage.heightAnchor.constraint(equalTo: computerImage.widthAnchor),
                //activity indicator
                activityInd.topAnchor.constraint(equalTo: computerImage.topAnchor),
                activityInd.bottomAnchor.constraint(equalTo: computerImage.bottomAnchor),
                activityInd.trailingAnchor.constraint(equalTo: computerImage.trailingAnchor),
                activityInd.leadingAnchor.constraint(equalTo: computerImage.leadingAnchor),
                //nameLabel
                nameLabel.topAnchor.constraint(equalTo: computerImage.bottomAnchor,
                                               constant: 32),
                nameLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -32),
                nameLabel.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 16),
                nameLabel.bottomAnchor.constraint(equalTo: computerNameLabel.topAnchor),
                //ComputernameLabel
                computerNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                computerNameLabel.leadingAnchor.constraint(equalTo:
                    scrollView.safeAreaLayoutGuide.leadingAnchor,constant: 16),
                computerNameLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -32),
                //intoDateLable
                introDateLabel.topAnchor.constraint(equalTo: computerNameLabel.bottomAnchor,
                                                    constant: 8),
                introDateLabel.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                                                        constant: 16),
                introDateLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -32),
                //computerIntoDate
                computerIntroDateLabel.topAnchor.constraint(equalTo: introDateLabel.bottomAnchor),
                computerIntroDateLabel.leadingAnchor.constraint(equalTo:
                    scrollView.safeAreaLayoutGuide.leadingAnchor,constant: 16),
                computerIntroDateLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -32),
                //DiscountDate
                discontDateLabel.topAnchor.constraint(equalTo: computerIntroDateLabel.bottomAnchor,
                                                    constant: 8),
                discontDateLabel.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                                                        constant: 16),
                discontDateLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -32),
                //ComputerDiscount lable
                computerDiscountLabel.topAnchor.constraint(equalTo: discontDateLabel.bottomAnchor),
                computerDiscountLabel.leadingAnchor.constraint(equalTo:
                    scrollView.safeAreaLayoutGuide.leadingAnchor,constant: 16),
                computerDiscountLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -32),
                //discription label
                discriptionLabel.topAnchor.constraint(equalTo: computerDiscountLabel.bottomAnchor,
                                                    constant: 8),
                discriptionLabel.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                                                        constant: 16),
                discriptionLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -32),
                computerDiscriptLabel.topAnchor.constraint(equalTo: discriptionLabel.bottomAnchor),
                computerDiscriptLabel.leadingAnchor.constraint(equalTo:
                    scrollView.safeAreaLayoutGuide.leadingAnchor,constant: 16),
                computerDiscriptLabel.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                computerDiscriptLabel.bottomAnchor.constraint(equalTo: extendButton.topAnchor,
                                                              constant: -5),
                //button
                extendButton.topAnchor.constraint(equalTo: computerDiscriptLabel.bottomAnchor,
                                                  constant: 5),
                extendButton.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,
                                                       constant: -16),
//                extendButton.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16),
                //previewLabel
                previewLabel.topAnchor.constraint(equalTo: extendButton.bottomAnchor, constant: 5),
                previewLabel.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                previewLabel.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor,
                                                      constant: 16),
                previewLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                // stack View
                stackView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor,
                                               constant: 8),
                stackView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: 16),
                stackView.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor,
                                                    constant: -16),
                stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                                  constant: -16),
                
                
                
            ]
            
            NSLayoutConstraint.activate(constraints)
        }
        
}

