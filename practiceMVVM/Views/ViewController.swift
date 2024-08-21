//
//  ViewController.swift
//  practiceMVVM
//
//  Created by Gulshan Khandale  on 21/08/24.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    let disposeBag:DisposeBag = DisposeBag()
    
    let viewModel:UserViewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myTableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        
        viewModel.users.bind(to: myTableView.rx.items(cellIdentifier: "UserCell", cellType: UserCell.self)) { row, user, cell in
            
            
            cell.userImageView.loadImage(url: user.picture.large)
            
            for userLbl in cell.labelCollections {
                switch userLbl.tag {
                case 0:
                    userLbl.text = "\(user.name.first) \(user.name.last)"
                case 1:
                    userLbl.text = user.location.city
                case 2:
                    userLbl.text = user.location.state
                case 3:
                    userLbl.text = user.location.country
                case 4:
                    userLbl.text = user.email
                case 5:
                    userLbl.text = DateUtility.formatDate(from: user.dateOfBirth.date, input: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", output: "dd/MM/yyyy")
                default:
                    print("No")
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.fetchUsers()
        
        myTableView.rx.contentOffset.flatMap { [weak self] _ -> Observable<Void> in
            
            guard let self = self else { return Observable.empty() }
            
            let contentHeight = self.myTableView.contentSize.height
            let scrollViewHeight = self.myTableView.bounds.size.height
            let contentOffset = self.myTableView.contentOffset.y
            
            if contentOffset > contentHeight - scrollViewHeight - 100 {
                return Observable.just(())
            }else{
                return Observable.empty()
            }
        }.throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.loadMoreUsers()
            })
            .disposed(by: disposeBag)
        
        myTableView.rx.modelSelected(UserData.self)
            .subscribe(onNext: { user in
                print("Selected User: \(user.email)")
            })
            .disposed(by: disposeBag)
    }


}

