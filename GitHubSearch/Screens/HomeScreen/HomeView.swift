//
//  HomeView.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import UIKit
import Combine

class HomeView: UIView {
    
    var hierarchyNotReady = true
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = .white
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false
    }
    
    init(frame: CGRect = .zero, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "hello")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel: HomeViewModel
    private var subscriptions = Set<AnyCancellable>()
}

private extension HomeView {
    func bind() {
        viewModel
            .$gitRepositoryResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.resultsTableView.reloadData()
            }.store(in: &subscriptions)
    }
}

private extension HomeView {
    
    func constructHierarchy() {
        addSubview(searchBar)
        addSubview(resultsTableView)
    }
    
    func activateConstraints() {
        activateSearchBarConstraints()
        activateResultsTableViewConstraints()
    }
    
    func activateSearchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func activateResultsTableViewConstraints() {
        NSLayoutConstraint.activate([
            resultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            resultsTableView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsTableView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hello")
        cell?.textLabel?.text = viewModel.gitRepositoryResult?.items?[indexPath.row].name ?? ""
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = viewModel.gitRepositoryResult?.items?[indexPath.row]
        print("\(selectedItem!.name!)")
    }
}
