//
//  Resolver+ReleaseInstances.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

public extension Resolver {

    // MARK: - Functions

    func releaseInstance<T>(_ protocolType: T.Type) {
        releaseInstance(name: hash(T.self))
    }

    func releaseInstance<T>(_ protocolType: T.Type, before completion: @escaping Completion<T>) {
        releaseInstance(name: hash(T.self), before: completion)
    }

    func releaseInstances(globalScope: ResolverGlobalScope) {
        releaseInstances(scope: getGlobalScope(globalScope))
    }

    func releaseInstances(scope: ResolverScopeProtocol) {
        releaseInstances(namespace: scope.namespace)
    }

    func releaseInstances() {
        sync { [weak self] in
            guard let self = self else {
                return
            }
            self.items.forEach { $0.value.instance = nil }
        }
    }

    func releaseInstance(name protocolName: String) {
        sync { [weak self] in
            guard let self = self else {
                return
            }
            self.items[protocolName]?.instance = nil
        }
    }

    func releaseInstance<T>(name protocolName: String, before completion: @escaping Completion<T>) {
        sync { [weak self] in
            guard let self = self else {
                return
            }
            completion(self.items[protocolName]?.instance as? T)
            self.items[protocolName]?.instance = nil
        }
    }
}
