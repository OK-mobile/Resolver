//
//  ResolverReferenceType+CustomStringConvertible.swift
//  ExampleTests
//
//  Created by dmitry.rybochkin on 18.11.2021.
//  Copyright © 2021 OK.RU. All rights reserved.
//

import Foundation

import ResolverProtocol

extension ResolverReferenceType: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible properties

    public var description: String {
        switch self {
        case .weak:
            return "weak"
        case .strong:
            return "strong"
        case .none:
            return "none"
        }
    }
}
