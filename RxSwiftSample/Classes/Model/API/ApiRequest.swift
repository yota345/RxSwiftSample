//
//  ApiRequest.swift
//  RxSwiftSample
//
//  Created by 沼田　洋太 on 2016/07/25.
//
//

import Alamofire
import RxSwift


/**
 API通信をするためのプロトコル
 - parameters: パラメーターを指定
 - baseURL: APIのドメインを指定
 - path: APIのパスを指定
 - method: CRUDを指定
*/
protocol APIRequest {
    var parameters: [String: AnyObject] { get }
    var baseURL: String { get }
    var path: String { get }
    var method: Alamofire.Method { get }
}


extension APIRequest {

    /// API通信の対象URL
    var url: String { return baseURL + path }


    /**
     API通信を実行する
     - returns: Observable:AnyObject
     - throws: Observable:ErrorType
    */
    func request() -> Observable<AnyObject> {
        return Observable.create { observer in
            let request = Alamofire.request(self.method, self.url, parameters: self.parameters, encoding: .URL)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        observer.onNext(response.result.value!)
                        observer.onCompleted()
                    case .Failure(let error):
                        observer.onError(error)
                    }
            }
            request.resume()

            return AnonymousDisposable {
                request.cancel()
            }
        }
    }

}
