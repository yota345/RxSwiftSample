//
//  EventsModel.swift
//  RxSwiftSample
//
//  Created by 沼田　洋太 on 2016/07/25.
//
//

import RxSwift
import Himotoki


/**
 Eventモデル
 - requestState: API通信の状態を扱う
 - disposeBag: RxSwiftで不要なstreamを削除するためのクラス
 */
struct EventsModel {
    internal let requestState = Variable(RequestState.stopped)
    fileprivate let disposeBag = DisposeBag()
    fileprivate let scheduler = RxScheduler.sharedInstance
}


extension EventsModel {

    /**
     - Eventの一覧を取得する
     - APIレスポンスは、self.requestStateに格納
    */
    func fetchEventList(_ count: Int) {
        requestState.value = .requesting

        EventsRequest
            .getEvents(count)
            .request()
            .timeout(5, scheduler: scheduler.serialBackground)
            .retry(1)
            .map{ try! decodeValue($0) as EventListResponse }
            .subscribe(
                onNext: {
                    self.requestState.value = .response($0)
                }, onError: {
                    self.requestState.value = .error($0)
                }
            )
            .addDisposableTo(disposeBag)
    }

}
