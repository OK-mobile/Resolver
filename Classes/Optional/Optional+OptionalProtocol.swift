//
//  Optional+OptionalProtocol.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 28.09.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation

extension Optional: OptionalProtocol {

    // MARK: - Static functions

    static func wrappedType() -> Any.Type {
        return Wrapped.self
    }
}
