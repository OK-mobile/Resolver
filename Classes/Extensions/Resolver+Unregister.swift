//
//  Resolver+Unregister.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

public extension Resolver {

    // MARK: - Functions

    func unregister<T>(_ protocolType: T.Type) {
        unregister(name: hash(T.self))
    }

    func unregister(globalScope: ResolverGlobalScope) {
        unregister(scope: getGlobalScope(globalScope))
    }

    func unregister(scope: ResolverScopeProtocol) {
        unregister(name: scope.namespace)
    }

    func unregister(name protocolName: String) {
        sync { [weak self] in
            guard let self = self else {
                return
            }
            self.items.removeValue(forKey: protocolName)
        }
    }

    func unregister(namespace: String) {
        sync { [weak self] in
            guard let self = self else {
                return
            }
            self.items = self.items.filter { $0.value.scope.namespace == namespace }
        }
    }
}
