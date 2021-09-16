//
//  ViewController.swift
//  iTunesSearchAPI
//
//  Created by Murat Can KOÇ on 15.09.2021.
//

import UIKit

class HomeViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        return table
    }()
    private let searchBar = UISearchController(searchResultsController: nil)
    
    var results: [Result]?
    var networkClient = NetworkClient()
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchResults()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "iTunes Search"
        setupTableView()
        configureSearhBar()
    }
    
    private func configureSearhBar() {
        navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
        searchBar.searchBar.autocapitalizationType = .none
        searchBar.searchBar.autocorrectionType = .no
        searchBar.searchBar.searchBarStyle = .minimal
        searchBar.searchBar.isTranslucent = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
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
//        cell.selectionStyle = .none
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        pendingRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.networkClient.fetchResults(withTerm: searchText, completion: { results in
                strongSelf.results = results
                strongSelf.tableView.reloadData()
            })
                }
        pendingRequestWorkItem = requestWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                              execute: requestWorkItem)
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

