//
//  ArticlePresenter.swift
//  NewYourTimes
//
//  Created by An Le  on 5/9/19.
//  Copyright © 2019 An Le. All rights reserved.
//

import Foundation



class ArticlePresenter: ArticlePresenterProtocol {
    
    weak var view: ArticleViewProtocol?
    var interactor: ArticleInteractorProtocol?
    
    private(set) var currentIndex: Int
    
    private(set) var currentArticle: ArticleDetailSection?
    private(set) var previousArticle: ArticleDetailSection?
    private(set) var nextArticle: ArticleDetailSection?
    
    init(currentIndex: Int) {
        self.currentIndex = currentIndex
    }
    
    func initialSetup() {
        interactor?.intialFetchArticle(at: currentIndex)
    }
    
    func willTransitionFromArticle(_ current: ArticleDetailSection, to article: ArticleDetailSection) {
        
        guard current.pageIndex != article.pageIndex else {
            return
        }
        
        if article.pageIndex > current.pageIndex {
            
            previousArticle = current
            currentArticle = article
            nextArticle = nil
            
            interactor?.loadNextArticle(for: article.pageIndex)
            
        } else {
            
            nextArticle = current
            currentArticle = article
            previousArticle = nil
            
            interactor?.loadPreviousArticle(for: article.pageIndex)
        }
    }
    
    func didInitialFetchSuccess(_ article: Article, index: Int) {

        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            let articleSection = self.convert(article, index: index)
            self.currentArticle = articleSection
            self.view?.updateViewWithArticle(articleSection)
            self.interactor?.loadNextArticle(for: index)
            self.interactor?.loadPreviousArticle(for: index)
        }
    }
    
    func didInitialFetchError(_ error: Error) {
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(error)
        }
    }
    
    func didLoadNextArticle(_ article: Article?, index: Int) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            if let article = article {
                self.nextArticle = self.convert(article, index: index)
            } else {
                self.nextArticle = nil
            }
        }
    }
    
    func didLoadPreviousArticle(_ article: Article?, index: Int) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            if let article = article {
                self.previousArticle = self.convert(article, index: index)
            } else {
                self.previousArticle = nil
            }
        }
    }
    
    private func convert(_ article: Article, index: Int) -> ArticleDetailSection {
        return ArticleDetailSection(title: article.title,
                                    publishedDate: article.publishedDate,
                                    publisher: article.publisher,
                                    author: article.author,
                                    snippet: article.snippet,
                                    image: article.banner(),
                                    pageIndex: index)
    }
}
