//
//  ApiResponse.swift
//  RxSwiftSample
//
//  Created by 沼田　洋太 on 2016/07/25.
//
//

import RxSwift
import Himotoki


/**
 API通信の状態を扱うプロトコル
 - .Stopped: API通信をまだ行っていない状態
 - .Requesting: API通信中
 - .Error(ErrorType): API通信でエラーが返ってきた状態
 - .Response(Decodable?): API通信でencode済みレスポンスを受け取っている
*/
enum RequestState {
    case Stopped
    case Requesting
    case Error(ErrorType)
    case Response(Decodable?)
}
