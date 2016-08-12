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
 - responseState: API通信の状態を扱う
 - disposeBag: RxSwiftで不要なstreamを削除するためのクラス
 */
struct EventsModel {
    internal let responseState = Variable(RequestState.Stopped)
    private let disposeBag = DisposeBag()
}


extension EventsModel {

    /**
     - Eventの一覧を取得する
     - APIレスポンスは、self.responseに格納
    */
    func fetchEventList(count: Int) {
        responseState.value = .Requesting

        EventsRequest
            .GetEvents(count)
            .request()
            .subscribe(
                onNext: {
                    let events = try! decodeValue($0) as EventListResponse
                    self.responseState.value = .Response(events)
                }, onError: {
                    self.responseState.value = .Error($0)
                }
            )
            .addDisposableTo(disposeBag)
    }

}
