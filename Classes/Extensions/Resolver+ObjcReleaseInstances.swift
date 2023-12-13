//
//  Resolver+ObjcReleaseInstances.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 10.06.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

public extension Resolver {

    // MARK: - Functions

    func releaseInstance(protocol protocolType: Protocol) {
        releaseInstance(name: hash(protocol: protocolType))
    }

    func releaseInstance(protocol protocolType: Protocol, before completion: @escaping ObjcCompletion) {
        releaseInstance(name: hash(protocol: protocolType), before: { instance in
            completion(instance)
        })
    }

    func releaseInstances(namespace: String) {
        sync { [weak self] in
            guard let self = self else {
                return
            }
            self.items.filter { $0.value.scope.namespace == namespace }.forEach { $0.value.instance = nil }
        }
    }

    func releaseInstance(class classType: AnyClass) {
        releaseInstance(name: hash(class: classType))
    }

    func releaseInstance(class classType: AnyClass, before completion: @escaping ObjcCompletion) {
        releaseInstance(name: hash(class: classType), before: { instance in
            completion(instance)
        })
    }
}
