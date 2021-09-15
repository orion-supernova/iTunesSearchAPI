//
//  ViewController.swift
//  iTunesSearchAPI
//
//  Created by Murat Can KOÇ on 15.09.2021.
//

import UIKit

class ViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        return table
    }()
    private let searchVC = UISearchController(searchResultsController: nil)
    
    var results: [Result]?
    var networkClient = NetworkClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        setupTableView()
        
        view.backgroundColor = .systemBackground
        title = "iTunes Search"
        
        fetchResults()
        createSearchBar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
        searchVC.searchBar.autocapitalizationType = .none
        searchVC.searchBar.autocorrectionType = .no
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func fetchResults() {
        networkClient.fetchResults(withTerm: "") { (results) in
            self.results = results
//            print(self.results)
            self.tableView.reloadData()
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results?.count == 0 {
                tableView.setMessage("No results")
            } else {
                tableView.clearBackground()
            }

        return results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as? ResultTableViewCell else { fatalError() }
        cell.result = results?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        networkClient.fetchResults(withTerm: text) { results in
            self.results = results
            self.tableView.reloadData()
        }
        print(text)
    }
}
extension UITableView {

    func setMessage(_ message: String) {
        let noResultMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        noResultMessage.text = message
        noResultMessage.textColor = .black
        noResultMessage.numberOfLines = 0
        noResultMessage.textAlignment = .center
        noResultMessage.font = UIFont(name: "TrebuchetMS", size: 20)
        noResultMessage.sizeToFit()

        self.backgroundView = noResultMessage
        self.separatorStyle = .none
    }

    func clearBackground() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

