//
//  EventsViewController.swift
//  RxSwiftSample
//
//  Created by 沼田　洋太 on 2016/08/02.
//
//

import UIKit
import RxSwift
import RxCocoa


/**
 Event一覧を表示するViewController
 */
class EventsViewController: UIViewController {
    fileprivate let viewModel = EventsViewModel()
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        /**
         スクロールが終わりかけているかを判定している
         FIXME: ロジックをViewModelに移す
        */
        tableView
            .rx.contentOffset
            .asObservable()
            .map { [unowned self] in
                $0.y + 300 >= self.tableView.contentSize.height - self.tableView.bounds.size.height
            }
            .bindTo(viewModel.scrollEndComing)
            .addDisposableTo(disposeBag)


        /**
         UITableViewDataSourceのラッパー
        */
        viewModel.events
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: "EventCell", cellType: UITableViewCell.self))
            { (row, element, cell) in
                cell.textLabel?.text = element.event.title
            }
            .addDisposableTo(disposeBag)


        /**
         viewModelのeventsをKVOみたいな感じでみていて、
         eventsの要素が変更されるとtableView.reloadData()が動く
        */
        viewModel
            .events
            .asDriver()
            .drive(onNext: {  [weak self] _ in
                self?.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
