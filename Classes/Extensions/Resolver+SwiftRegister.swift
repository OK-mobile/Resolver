//
//  Resolver+SwiftRegister.swift
//  Odnoklassniki
//
//  Created by dmitry.rybochkin on 19.02.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

public extension Resolver {

    // MARK: - Functions

    func register(closure: @escaping (ResolverType) -> Void) {
        sync { [weak self] in
            guard let self = self else {
                return
            }
            closure(self)
        }
    }

    func register<T>(_ protocolType: T.Type, factory: @escaping SwiftFactory<T>) {
        add(scope: defaultScope, factory: factory, completion: nil)
    }

    func register<T>(_ protocolType: T.Type, globalScope: ResolverGlobalScope, factory: @escaping SwiftFactory<T>) {
        add(scope: getGlobalScope(globalScope), factory: factory, completion: nil)
    }

    func register<T>(_ protocolType: T.Type, scope: ResolverScopeProtocol, factory: @escaping SwiftFactory<T>) {
        add(scope: scope, factory: factory, completion: nil)
    }

    func register<T>(_ protocolType: T.Type, factory: @escaping SwiftFactory<T>, completion: @escaping SwiftCompletion<T>) {
        add(scope: defaultScope, factory: factory, completion: completion)
    }

    func register<T>(_ protocolType: T.Type, globalScope: ResolverGlobalScope, factory: @escaping SwiftFactory<T>, completion: @escaping SwiftCompletion<T>) {
        add(scope: getGlobalScope(globalScope), factory: factory, completion: completion)
    }

    func register<T>(_ protocolType: T.Type, scope: ResolverScopeProtocol, factory: @escaping SwiftFactory<T>, completion: @escaping SwiftCompletion<T>) {
        add(scope: scope, factory: factory, completion: completion)
    }
}

private extension Resolver {

    // MARK: - Private functions

    func add<T>(scope: ResolverScopeProtocol, factory: @escaping SwiftFactory<T>, completion: SwiftCompletion<T>?) {
        let protocolName = hash(T.self)
        async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            if self.items.keys.contains(protocolName) {
                assert(false, "Resolver: factory for protocol \(protocolName) alreadey exist in container")
            }

            self.items[protocolName] = Item(scope: scope, instance: nil, factory: factory, completion: { resolver, resolvedObject in
                completion?(resolver, resolvedObject as? T)
            })
        }
    }
}
