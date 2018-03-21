//
//  ApiResponse.swift
//  RxSwiftSample
//
//  Created by 沼田　洋太 on 2016/07/25.
//
//

import RxSwift
import Himotoki
import protocol Himotoki.Decodable


/**
 API通信の状態を扱うプロトコル
 - .Stopped: API通信をまだ行っていない状態
 - .Requesting: API通信中
 - .Error(ErrorType): API通信でエラーが返ってきた状態
 - .Response(Decodable?): API通信でencode済みレスポンスを受け取っている
*/
enum RequestState {
    case stopped
    case requesting
    case error(Error)
    case response(Decodable?)
}
