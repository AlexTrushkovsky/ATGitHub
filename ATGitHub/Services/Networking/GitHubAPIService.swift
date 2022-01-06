//
//  GitHubAPIService.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol GitHubAPIRepositoryProvider {
    func searchRepositories(for query: String, page: Int) -> Observable<[RepositoryEntity]?>
    func getCurrentUser(completion: @escaping ((Owner?) -> ()))
    func getLastActivity(userName: String, completion: @escaping (([Event]?) -> ()))
    func getStarredByUser(completion: @escaping (([RepositoryEntity]?) -> ()))
    func starRepoRequest(bool: Bool, userName: String, repoName: String)
}

protocol GitHubAPIProvider: GitHubAPIRepositoryProvider { }

final class GitHubAPIService: GitHubAPIProvider {
    
    private let storage: APIStorage
    
    init() {
        self.storage = UserDefaultsStorage()
    }
    
   private func performRequest(api: GitHubAPI) -> Observable<Data?> {
        guard let url = api.url else { return Observable.empty() }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let headers = api.headers
        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        return URLSession.shared.rx.data(request: request)
            .map { Optional.init($0) }
            .catch { (error) -> Observable<Data?> in
                throw error
            }
    }
    
    private func performUserRequest(api: GitHubAPI, completion: @escaping ((Owner?) -> ())) {
        guard let url = api.url else { return completion(nil) }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let headers = api.headers
        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            guard let data = data else { return completion(nil)}
            let decodedData = try? decoder.decode(Owner.self, from: data)
            completion(decodedData)
        }
        session.resume()
    }
    
    private func performActivityRequest(api: GitHubAPI, completion: @escaping (([Event]?) -> ())) {
        guard let url = api.url else { return completion(nil) }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let headers = api.headers
        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            guard let data = data else { return }
            let decodedData = try? decoder.decode([Event].self, from: data)
            completion(decodedData)
        }
        session.resume()
    }
    
    private func performStarredRequest(api: GitHubAPI, completion: @escaping (([RepositoryEntity]?) -> ())) {
        guard let url = api.url else { return completion(nil) }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let headers = api.headers
        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            guard let data = data else { return }
            let decodedData = try? decoder.decode([RepositoryEntity].self, from: data)
            completion(decodedData)
        }
        session.resume()
    }
    
    private func performStarRepoRequest(api: GitHubAPI, bool: Bool) {
        guard let url = api.url else { return }
        var request = URLRequest(url: url)
        
        if bool {
            request.httpMethod = "PUT"
        } else {
            request.httpMethod = "DELETE"
        }
        
        let headers = api.headers
        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in })
        session.resume()
    }
    
}

extension GitHubAPIService: GitHubAPIRepositoryProvider {
    func starRepoRequest(bool: Bool, userName: String, repoName: String) {
        guard let token = storage.token else { return }
        performStarRepoRequest(api: .starRepoAction(userName: userName, repoName: repoName, token: token), bool: bool)
    }
    
    func getStarredByUser(completion: @escaping (([RepositoryEntity]?) -> ())) {
        guard let token = storage.token else { return completion(nil) }
        let api: GitHubAPI = .starred(token: token)
        performStarredRequest(api: api) { starredRepos in
            completion(starredRepos)
        }
        completion(nil)
    }
    
    func getLastActivity(userName: String, completion: @escaping (([Event]?) -> ())) {
        let api: GitHubAPI = .lastEvents(userName: userName)
        performActivityRequest(api: api) { activityRepos in
            completion(activityRepos)
        }
        completion(nil)
    }
    
    func getCurrentUser(completion: @escaping ((Owner?) -> ())) {
        guard let token = storage.token else { return completion(nil) }
        let api: GitHubAPI = .user(token: token)
        performUserRequest(api: api) { user in
            completion(user)
        }
    }
    
    func getStarredByCurrentUser() -> Observable<[RepositoryEntity]?> {
        guard let token = storage.token else { return .empty() }
        let api: GitHubAPI = .starred(token: token)
        
        return performRequest(api: api)
            .map { (data) -> [RepositoryEntity]? in
                guard let data = data,
                      let response = try? JSONDecoder().decode(RepositoriesSearchResult.self, from: data) else {
                          return nil
                      }
                return response.items
            }
            .map { (repositories) -> [RepositoryEntity]? in
                return repositories
            }
            .catch { (error) in
                throw error
            }
    }
    
    
    func searchRepositories(for query: String, page: Int) -> Observable<[RepositoryEntity]?> {
        guard let token = storage.token else { return .empty() }
        
        let input = SearchInput(query: query, page: page, token: token)
        let api: GitHubAPI = .search(model: input)
        
        return performRequest(api: api)
            .map { (data) -> [RepositoryEntity]? in
                guard let data = data,
                      let response = try? JSONDecoder().decode(RepositoriesSearchResult.self, from: data) else {
                    return nil
                }
                return response.items
            }
            .map { (repositories) -> [RepositoryEntity]? in
                return repositories
            }
            .catch { (error) in
                throw error
            }
    }
}

extension GitHubAPIService: StaticFactory {
    enum Factory {
        static let build: GitHubAPIProvider = GitHubAPIService()
    }
}
