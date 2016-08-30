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
struct EventsViewModel {

    private let eventModel = EventsModel()
    private let scheduler = RxScheduler.sharedInstance
    private let disposeBag = DisposeBag()
    internal let events: Variable<[EventListResponse.Events]> = Variable([])
    internal let viewState = Variable(ViewState.Blank)
    internal let scrollEndComing = Variable(false)


    init() {

        scrollEndComing
            .asObservable()
            .subscribeNext {
                if self.viewState.value.fetchEnabled() && $0 {
                    self.eventModel.fetchEventList( self.nextEventsCount() )
                }
            }
            .addDisposableTo(disposeBag)


        /**
         APIの結果をsubscribeしている
        */
        eventModel
            .requestState
            .asObservable()
            .subscribeOn(scheduler.serialBackground)
            .observeOn(scheduler.main)
            .subscribeNext {
                self.subscribeState($0)
            }
            .addDisposableTo(disposeBag)

    }


    /**
     APIの通信状況とViewの状態を接続している
    */
    func subscribeState(state: RequestState) {
        switch state {
        case .Stopped:
            self.viewState.value = .Blank
        case .Requesting:
            self.viewState.value = .Requesting
        case .Error(let error):
            self.viewState.value = .Error(error)
        case .Response(let response):
            let events = (response as? EventListResponse)?.events ?? []
            self.viewState.value = .Working
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
