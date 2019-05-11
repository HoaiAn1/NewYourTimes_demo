//
//  MockArticleRepository.swift
//  NewYourTimesTests
//
//  Created by An Le  on 5/11/19.
//  Copyright © 2019 An Le. All rights reserved.
//

import Foundation
@testable import NewYourTimes



class MockArticleRepository: ArticleRepositoryProtocol {
    
    private var response: Response
    var articles: [Article]?
    
    init(response: Response) {
        self.response = response
    }
    
    func fetchArticles(pageOffset: Int,
                       pageSize: Int,
                       fetchStrategy: FetchStrategy,
                       completion: ReadCompletionBlock<[Article]>?) {
        
        switch response {
        case .hit:
            articles = [TestArticle]
            completion?(.success([TestArticle]))
        case .miss:
            articles = []
            completion?(.success([]))
        case .error:
            articles = nil
            completion?(.failure(TestError))
        }
    }
}


