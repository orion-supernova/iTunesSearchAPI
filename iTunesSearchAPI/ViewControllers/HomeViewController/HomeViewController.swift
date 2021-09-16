//
//  ViewController.swift
//  iTunesSearchAPI
//
//  Created by Murat Can KOÇ on 15.09.2021.
//

import UIKit
import Kingfisher

enum SectionType: Int {
    case zeroToHundred = 0
    case hundredToTwofifty = 1
    case twofiftyTofivehundred = 2
    case fivehundredPlus = 3
}

class HomeViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        return table
    }()
    private let searchBar = UISearchController(searchResultsController: nil)
    
    private var resultList = [ResultList]()
    private var firstSec = [String]()
    private var secondSec = [String]()
    private var thirdSec = [String]()
    private var fourthSec = [String]()
    
    
    
    private var models = [ResultListTableViewCellModel]()
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
        APICaller.shared.getResults(term: "") { [weak self] closureResult in
            switch closureResult {
            case .success(let resultList):
                self?.resultList = resultList
                self?.models = resultList.compactMap({ ResultListTableViewCellModel(screenshotUrls: $0.screenshotUrls)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = SectionType(rawValue: section)
        switch sectionType {
        case .zeroToHundred:
            return self.firstSec.count
        case .hundredToTwofifty:
            return self.secondSec.count
        case .twofiftyTofivehundred:
            return self.thirdSec.count
        case .fivehundredPlus:
            return self.fourthSec.count
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionType = SectionType(rawValue: section)
        switch sectionType {
        case .zeroToHundred:
            return "0-100"
        case .hundredToTwofifty:
            return "100-250"
        case .twofiftyTofivehundred:
            return "250-500"
        case .fivehundredPlus:
            return "500+"
        case .none:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as? ResultTableViewCell else { fatalError() }
        let sectionType = SectionType(rawValue: indexPath.section)
        switch sectionType {
        case .zeroToHundred:
            cell.configureCell(imageUrl: self.firstSec[indexPath.row])
        case .hundredToTwofifty:
            cell.configureCell(imageUrl: self.secondSec[indexPath.row])
        case .twofiftyTofivehundred:
            cell.configureCell(imageUrl: self.thirdSec[indexPath.row])
        case .fivehundredPlus:
            cell.configureCell(imageUrl: self.fourthSec[indexPath.row])
        case .none:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if firstSec.count == 0 && secondSec.count == 0 && thirdSec.count == 0 && fourthSec.count == 0 {
                tableView.setMessage("No results")
            } else {
                tableView.clearBackground()
                return 4
            }
        return 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        APICaller.shared.getResults(term: text) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let resultList):
                strongSelf.resultList = resultList
                strongSelf.firstSec.removeAll()
                strongSelf.secondSec.removeAll()
                strongSelf.thirdSec.removeAll()
                strongSelf.fourthSec.removeAll()
                for result in resultList {
                    for url in result.screenshotUrls {
                        if let imageUrl = URL(string: url) {
                            let data = try? Data(contentsOf: imageUrl)
                            let imageData = NSData(data: data!)
                            if Double(imageData.count)/1000 <= 100.0 && Double(imageData.count)/1000 > 0 {
                                strongSelf.firstSec.append(url)
                                DispatchQueue.main.async {
                                    strongSelf.tableView.reloadData()
                                }
                            } else if Double(imageData.count)/1000 <= 250.0 && Double(imageData.count)/1000 > 100 {
                                strongSelf.secondSec.append(url)
                            } else if Double(imageData.count)/1000 <= 500.0 && Double(imageData.count)/1000 > 250 {
                                strongSelf.thirdSec.append(url)
                            } else {
                                strongSelf.fourthSec.append(url)
                            }
                        }
                        
                    }
                }
                strongSelf.models = resultList.compactMap({ ResultListTableViewCellModel(screenshotUrls: $0.screenshotUrls)})
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                    strongSelf.searchBar.dismiss(animated: true, completion: nil)
                    print(resultList)
                }
            case .failure(let error):
                print(error)
            }
        }
        print(text)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        pendingRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem { [weak self] in
            
            APICaller.shared.getResults(term: searchText) { [weak self] result in
                switch result {
                case .success(let resultList):
                    self?.resultList = resultList
//                    self?.models = resultList.compactMap({ ResultListTableViewCellModel(screenshotUrls: $0.screenshotUrls)})
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
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

