//
//  EventsRequest.swift
//  RxSwiftSample
//
//  Created by 沼田　洋太 on 2016/07/25.
//
//

import Alamofire


/**
 EventのAPI通信情報を設定
*/
enum EventsRequest {
    case GetEvents(Int)
}


extension EventsRequest: APIRequest {

    var baseURL: String { return GlobalConstant.atndBase }


    var method: Alamofire.Method {
        switch self {
        case .GetEvents:
            return .GET
        }
    }


    var path: String {
        switch self {
        case .GetEvents:
            return GlobalConstant.atndEvents
        }
    }


    var parameters: [String: AnyObject] {
        switch self {
        case .GetEvents(let count):
            return [
                "format": "json",
                "start": count,
                "count": 15
            ]
        }
    }

}
