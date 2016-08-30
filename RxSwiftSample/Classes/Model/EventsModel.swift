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
    internal let requestState = Variable(RequestState.Stopped)
    private let disposeBag = DisposeBag()
}


extension EventsModel {

    /**
     - Eventの一覧を取得する
     - APIレスポンスは、self.requestStateに格納
    */
    func fetchEventList(count: Int) {
        requestState.value = .Requesting

        EventsRequest
            .GetEvents(count)
            .request()
            .subscribe(
                onNext: {
                    let events = try! decodeValue($0) as EventListResponse
                    self.requestState.value = .Response(events)
                }, onError: {
                    self.requestState.value = .Error($0)
                }
            )
            .addDisposableTo(disposeBag)
    }

}
