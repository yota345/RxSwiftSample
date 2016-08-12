//
//  ViewState.swift
//  RxSwiftSample
//
//  Created by 沼田　洋太 on 2016/07/26.
//
//


/**
 Viewの状態を扱うenum
 - .Working: 描画する要素があり、アプリが正常に動いている状態
 - .Blank: 描画する要素がない状態
 - .Requesting: 描画する要素を読み込んでいる状態
 - .Error(ErrorType): エラーが起きている状態
*/
enum ViewState {
    case Working
    case Blank
    case Requesting
    case Error(ErrorType)
}
