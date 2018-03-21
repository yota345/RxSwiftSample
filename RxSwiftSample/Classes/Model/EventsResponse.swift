//
//  EventsResponse.swift
//  RxSwiftSample
//
//  Created by 沼田　洋太 on 2016/07/25.
//
//

import Himotoki
import protocol Himotoki.Decodable


/**
 Event一覧を取得した後のJSONエンコードを設定
*/
struct EventListResponse: Decodable {
    internal let results_returned: Int
    internal let results_start: String
    internal let events: [Events]

    static func decode(_ e: Extractor) throws -> EventListResponse {
        return try EventListResponse(
            results_returned:   e <| "results_returned",
            results_start:      e <| "results_start",
            events:             e <|| "events"
        )
    }


    struct Events: Decodable {
        internal let event: Event

        static func decode(_ e: Extractor) throws -> Events {
            return try Events (
                event: e <| "event"
            )
        }


        struct Event: Decodable {
            internal let event_id: Int
            internal let title: String
            internal let description: String
            internal let event_url: String
            internal let url: String?
            internal let address: String
            internal let place: String

            static func decode(_ e: Extractor) throws -> Event {
                return try Event (
                    event_id:    e <| "event_id",
                    title:       e <| "title",
                    description: e <| "description",
                    event_url:   e <| "event_url",
                    url:         e <|? "url",
                    address:     e <| "address",
                    place:       e <| "place"
                )
            }
        }

    }

}
