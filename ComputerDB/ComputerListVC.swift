//
//  ViewController.swift
//  ComputerDB
//
//  Created by Сергей Прокопьев on 12.03.2020.
//  Copyright © 2020 PelmondoProd. All rights reserved.
//

import UIKit

class ComputerListVC: UIViewController, ComputersGet {
   
    
    //MARK: - UI Elements
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        table.estimatedRowHeight = 42
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundColor = .white
        bar.searchBarStyle = .minimal
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    

    let appDelegate = AppDelegate()
    private var computers = [Items]()
    private var displayComputers = [Items]()
    private var isSearched = false
    private let cellIdOne = "without company"
    private let cellIdTwo = "with company"
    
    private func setUpTable() {
        tableView.register(ComputerCell.self, forCellReuseIdentifier: cellIdOne)
        tableView.register(ComputerCompanyCell.self, forCellReuseIdentifier: cellIdTwo)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Computers"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(searchBar)
        view.addSubview(tableView)
        setUpTable()
        setUpLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        conectionCheck()
        appDelegate.network.delegate = self
        appDelegate.network.getComputersList()
        
    }
    
    //MARK: - Layout settings
    fileprivate func setUpLayout() {
        let constraints = [
            //tableView Layout
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            // SearchBar Layout
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    //MARK: - get data
    
    func getComputers(computers: Data) {
        do {
            let computerList = try
                JSONDecoder().decode(Response.self, from: computers)
            if !isSearched {
                self.computers += computerList.items
                self.displayComputers = self.computers
            } else {
                self.displayComputers = computerList.items
            }
        } catch {
            print(error)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchData() {
        appDelegate.network.updatePage()
        DispatchQueue.main.async {
            self.appDelegate.network.getComputersList()
        }
    }
}


//MARK: - TableView Data and Delegate
extension ComputerListVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayComputers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let companyName = displayComputers[indexPath.row].company {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdTwo, for: indexPath) as! ComputerCompanyCell
            cell.computerNameLabel.text = displayComputers[indexPath.row].name
            cell.computerCompanyLabel.text = companyName.name
             return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdOne, for: indexPath) as! ComputerCell
            cell.computerNameLabel.text = displayComputers[indexPath.row].name
             return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isSearched {
            let lastRow = indexPath.row
            if lastRow == displayComputers.count - 1 {
                fetchData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let nextVC = ComputerCardVC()
        nextVC.navigationItem.title = displayComputers[indexPath.row].name
        nextVC.computerId = displayComputers[indexPath.row].id
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: - UISearch bar delegate
extension ComputerListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayComputers = computers.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil}
        isSearched = true
        if searchText == "" {
            displayComputers = computers
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchName = searchBar.text else {return}
        appDelegate.network.getSearchUrl(searchName)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearched = false
        displayComputers = computers
        self.searchBar.text = ""
        self.searchBar.showsCancelButton = false
        tableView.reloadData()
        self.searchBar.resignFirstResponder()
    }
}

 //MARK: - connection check
extension ComputerListVC {
    private func conectionCheck() {
        if Reachability.isConnectedToNetwork() == true {
//            print("It's okay")
        } else {
            let alert = UIAlertController(title: nil, message: "Internet connections failed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            }))
            self.present(alert,animated: true, completion: nil)
        }
    }
}
