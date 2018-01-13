//
//  EventsViewModel.swift
//  RxSwiftSample
//
//  Created by 沼田　洋太 on 2016/07/25.
//
//

import RxSwift
import UIKit


/**
 EventsViewControllerの状態を扱うViewModel
 - eventModel: Eventに関するデータを扱うモデル
 - scheduler: RxSwiftで非同期通信を行うためのシングルトン
 - disposeBag: RxSwiftで不要なstreamを削除するためのクラス
 - events: Event一覧を格納
 - viewState: Viewの状態を表現
 - scrollEndComing: tableViewのスクロールが終わりかけているかを判定した結果
*/
class EventsViewModel {

    fileprivate let eventModel = EventsModel()
    fileprivate let scheduler = RxScheduler.sharedInstance
    fileprivate let disposeBag = DisposeBag()
    internal let events: Variable<[EventListResponse.Events]> = Variable([])
    internal let viewState = Variable(ViewState.blank)
    internal let scrollEndComing = Variable(false)


    init() {

        scrollEndComing
            .asObservable()
            .subscribe(onNext: { bool in
                if self.viewState.value.fetchEnabled() && bool {
                    self.eventModel.fetchEventList( self.nextEventsCount() )
                }
            })
            .addDisposableTo(disposeBag)


        /**
         APIの結果をsubscribeしている
        */
        eventModel
            .requestState
            .asObservable()
            .observeOn(scheduler.main)
            .subscribe(onNext: { requestState in
                self.subscribeState(requestState)
            })
            .addDisposableTo(disposeBag)
    }


    /**
     APIの通信状況とViewの状態を接続している
    */
    func subscribeState(_ state: RequestState) {
        switch state {
        case .stopped:
            self.viewState.value = .blank
        case .requesting:
            self.viewState.value = .requesting
        case .error(let error):
            self.viewState.value = .error(error)
        case .response(let response):
            let events = (response as? EventListResponse)?.events ?? []
            self.viewState.value = .working
            self.scrollEndComing.value = false
            self.events.value += events
        }
    }


    /**
     ATND APIで、未取得のイベントを取ってくるために、これまでに取得したイベント数 + 1をを指定
    */
    func nextEventsCount() -> Int {
        return self.events.value.count + 1
    }

}
