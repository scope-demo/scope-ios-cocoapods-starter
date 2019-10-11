//
//  Geolocation.swift
//  ScopeAgent-Reference
//
//  Copyright © 2019 Undefined Labs. All rights reserved.
//

/**
* SCOPE
*
* Geolocation class has two method method that calls a external service with HTTP.
* The external service is also instrumented with Scope so its traces will appear in our test result
* ScopeAgent is not imported here but request / responses will apear in Scope
* The payload is not not currently instrumented, but you can check SCOPE_INSTRUMENTATION_HTTP_PAYLOADS
* in test environment variables
*/

import Alamofire
import CoreLocation
import Foundation

class Geolocation {
    class func getLocationWithAlamofire(identifier: String, completion: @escaping ((CLLocation?) -> Void)) {
        var url = URL(string: "http://flask-example-project.codescope.com:8000/car/")!
        url.appendPathComponent(identifier)

        SessionManager.default.request(url).responseJSON { response in
            if let result = response.result.value,
                let JSON = result as? NSDictionary,
                let lat = JSON["lat"] as? Double,
                let lon = JSON["lon"] as? Double {
                let location = CLLocation(latitude: lat, longitude: lon)
                completion(location)
            } else {
                completion(nil)
            }
        }
    }

    class func getLocationWithURLSession(identifier: String, completion: @escaping ((CLLocation?) -> Void)) {
        var url = URL(string: "http://flask-example-project.codescope.com:8000/car/")!
        url.appendPathComponent(identifier)

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data,
                error == nil,
                let JSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let lat = JSON["lat"] as? Double,
                let lon = JSON["lon"] as? Double {
                let location = CLLocation(latitude: lat, longitude: lon)
                completion(location)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}

/**
 * SCOPE
 *
 * Identifiers struct has two identifiers to pass geolocation service, good_identifier should work correctly,
 * bad_identifier should produce a server failure because it is not a correct UUID
 */
struct Identifiers {
    static let good_identifier = "9E219725-490E-4509-A42D-D0388DF317D4"
    static let bad_identifier = "XE219725-490E-4509-A42D-D0388DF317D4"
}
