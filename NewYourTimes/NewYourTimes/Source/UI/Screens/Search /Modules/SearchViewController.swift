//
//  SearchViewController.swift
//  NewYourTimes
//
//  Created by An Le  on 5/9/19.
//  Copyright © 2019 An Le. All rights reserved.
//

import UIKit




class SearchViewController: ACVViewController, SearchViewProtocol {
   
    var presenter: SearchPresenterProtocol?
    
    weak var searchBar: UISearchBar?
    
    private var sections = [SectionViewModel]()
    
    override var isPullToRefreshEnabled: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        acvAdapter.dataSource = self
        acvAdapter.delegate = self
    }
}



extension SearchViewController {
    
    func showError(_ error: Error) {
        
        let alertController = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .cancel, handler: nil)
        )
        
        present(alertController, animated: true, completion: nil)
    }

    func showEmptyView() {
        emptyLabel.isHidden = false
        emptyLabel.text = "No result".localized()
    }
    
    func hideEmptyView() {
        emptyLabel.isHidden = true
        emptyLabel.text = nil
    }
    
    func showLoadingIndicator() {
        emptyLabel.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func updateSearchBarText(_ text: String) {
        searchBar?.text = text
    }
    
    func removeFocusOnSearchBar() {
        searchBar?.resignFirstResponder()
    }
    
    func reloadView(with data: [SectionViewModel]) {
        sections = data
        acvAdapter.reloadAllSections()
    }
}



extension SearchViewController: ACVAdapterDataSource {
    
    func sectionViewModelsForAdapter(_ adapter: ACVAdapter) -> [SectionViewModel] {
        return sections
    }
}



// MARK: === USER INTERACTION ===
extension SearchViewController: ACVAdapterDelegate, UISearchBarDelegate {
    
    func didSelectSection(_ section: Int) {
        
        if let sectionModel = sections[section] as? SearchKeywordSection,
            let addtionalItem = sectionModel.itemModels.first as? AdditionalInfoItem {
            
            presenter?.didSelectSearchKeyword(addtionalItem.info)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            presenter?.searchBarButtonDidEnter(text)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        presenter?.searchBarDidBeginEditing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchBarTextDidChange(searchText)
    }
    
}



extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        view.isHidden = false
    }
}

