//
//  Resolver+ObjcUnregister.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 10.06.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

public extension Resolver {

    // MARK: - Functions

    func unregister(protocol protocolType: Protocol) {
        unregister(name: hash(protocol: protocolType))
    }

    func unregister(class classType: AnyClass) {
        unregister(name: hash(class: classType))
    }
}
