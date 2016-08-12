//
//  RxScheduler.swift
//  RxSwiftSample
//
//  Created by 沼田　洋太 on 2016/07/25.
//
//

import RxSwift
import RxCocoa


/**
 RxSwiftで同期・非同期・並列処理をするためのシングルトン
 - main: 同期処理
 - serialBackground: 非同期処理
 - concurrentBackground: 並列処理
*/
struct RxScheduler {
    static let sharedInstance = RxScheduler()
    let main: SerialDispatchQueueScheduler
    let serialBackground: SerialDispatchQueueScheduler
    let concurrentBackground: ImmediateSchedulerType

    init() {
        main = MainScheduler.instance
        serialBackground = SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Default)

        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = NSQualityOfService.UserInitiated
        concurrentBackground = OperationQueueScheduler(operationQueue: operationQueue)
    }
}
