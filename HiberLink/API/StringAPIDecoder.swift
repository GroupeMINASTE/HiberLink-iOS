//
//  StringAPIDecoder.swift
//  HiberLink
//
//  Created by Nathan FALLET on 09/05/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation
import APIRequest

class StringAPIDecoder: APIDecoder {
    
    func decode<T>(from data: Data, as type: T.Type) -> T? where T : Decodable {
        // Decode string
        return String(data: data, encoding: .utf8) as? T
    }
    
}
