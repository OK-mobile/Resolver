//
//  Resolver+ObjcResolve.swift
//  Odnoklassniki
//
//  Created by dmitry.rybochkin on 19.02.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

@objc
public extension Resolver {

    // MARK: - Functions

    func resolveNew(protocol protocolType: Protocol) -> Any? {
        resolveObjC(protocol: protocolType, isSingletone: false)
    }

    func resolveNew(class classType: AnyClass) -> Any? {
        resolveObjC(class: classType, isSingletone: false)
    }

    func resolve(protocol protocolType: Protocol) -> Any? {
        resolveObjC(protocol: protocolType, isSingletone: true)
    }

    func resolve(class classType: AnyClass) -> Any? {
        resolveObjC(class: classType, isSingletone: true)
    }

    func find(protocol protocolType: Protocol) -> Any? {
        findObjC(protocol: protocolType)
    }

    func find(class classType: AnyClass) -> Any? {
        findObjC(class: classType)
    }
}
