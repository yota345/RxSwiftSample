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
    case getEvents(Int)
}


extension EventsRequest: APIRequest {

    var baseURL: String { return GlobalConstant.atndBase }


    var method: Alamofire.HTTPMethod {
        switch self {
        case .getEvents:
            return .get
        }
    }


    var path: String {
        switch self {
        case .getEvents:
            return GlobalConstant.atndEvents
        }
    }


    var parameters: [String: AnyObject] {
        switch self {
        case .getEvents(let count):
            return [
                "format": "json" as AnyObject,
                "start": count as AnyObject,
                "count": 15 as AnyObject
            ]
        }
    }

}
