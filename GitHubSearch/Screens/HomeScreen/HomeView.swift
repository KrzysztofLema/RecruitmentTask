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
        bind()
        hierarchyNotReady = false
    }
    
    init(frame: CGRect = .zero, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search for git repository"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: "hello")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let viewModel: HomeViewModel
    private var subscriptions = Set<AnyCancellable>()
}

private extension HomeView {
    func bind() {
        viewModel.$gitRepositoryResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.resultsTableView.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.$homeViewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                switch viewState {
                case .defaultState:
                    self?.loadingIndicator.stopAnimating()
                case .isLoadingData:
                    self?.loadingIndicator.startAnimating()
                case .loadedData:
                    self?.loadingIndicator.stopAnimating()
                }
            }.store(in: &subscriptions)
    }
}

private extension HomeView {
    
    func constructHierarchy() {
        addSubview(searchBar)
        addSubview(resultsTableView)
        resultsTableView.addSubview(loadingIndicator)
    }
    
    func activateConstraints() {
        activateSearchBarConstraints()
        activateResultsTableViewConstraints()
        activateLoadingIndicatorConstraints()
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
    
    func activateLoadingIndicatorConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: resultsTableView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: resultsTableView.centerYAnchor)
        ])
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.gitRepositoryResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "hello") as? RepositoryTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.gitRepositoryResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = viewModel.gitRepositoryResults[indexPath.row]
        viewModel.selectedRepository.send(selectedItem)
    }
}

extension HomeView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar
            .publisher(for: \.text)
            .map { $0 ?? "" }
            .assign(to: \.searchInput , on: viewModel)
            .store(in: &subscriptions)
    }
}
