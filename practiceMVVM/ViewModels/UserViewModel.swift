//
//  UserViewModel.swift
//  practiceMVVM
//
//  Created by Gulshan Khandale  on 21/08/24.
//

import Foundation
import RxSwift
import RxCocoa

class UserViewModel {
    
    private let disposeBag:DisposeBag = DisposeBag()
    
    let users: BehaviorSubject<[UserData]> = BehaviorSubject(value: [])
    
    private var currentPage:Int = 1
    private var pageLimit:Int = 10
    private var isLoading:Bool = false
    
    func fetchUsers(){
        loadUsers(page: currentPage)
    }
    
    func loadMoreUsers(){
        guard !isLoading else { return }
        currentPage += 1
        loadUsers(page: currentPage)
    }
    
    
    private func loadUsers(page: Int){
        
        self.isLoading = true
        
        let queryData:[String: Any] = [
            "results": self.pageLimit,
            "page": page,
            "exc":"login"
        ]
        
        NetworkManager.shared.makeNetworkCall(endpoint: "/api", method: .GET, contentType: .JSON, payloadData: [:], queryParams: queryData, model: User.self).observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] userResponse in
                guard let self = self else { return }
                var currentUsers = try! self.users.value()
                currentUsers.append(contentsOf: userResponse.results)
                self.users.onNext(currentUsers)
                self.isLoading = false
            },
                       onError: { [weak self] error in
                print("Error: \(error.localizedDescription)")
                self?.isLoading = false
            }
            ).disposed(by: disposeBag)
        
        
    }
    
    
    
}
