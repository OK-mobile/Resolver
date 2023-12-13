//
//  Resolver+ObjcRegister.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 01.02.2021.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

public extension Resolver {

    // MARK: - Functions

    func register(closure: @escaping (ResolverProtocol) -> Void) {
        sync { [weak self] in
            guard let self = self else {
                return
            }
            closure(self)
        }
    }

    func register(protocol protocolType: Protocol, factory: @escaping (ResolverProtocol) -> Any?) {
        add(protocol: protocolType, scope: defaultScope, factory: factory, completion: nil)
    }

    func register(protocol protocolType: Protocol, globalScope: ResolverGlobalScope, factory: @escaping (ResolverProtocol) -> Any?) {
        add(protocol: protocolType, scope: getGlobalScope(globalScope), factory: factory, completion: nil)
    }

    func register(protocol protocolType: Protocol, scope: ResolverScopeProtocol, factory: @escaping (ResolverProtocol) -> Any?) {
        add(protocol: protocolType, scope: scope, factory: factory, completion: nil)
    }

    func register(protocol protocolType: Protocol, factory: @escaping (ResolverProtocol) -> Any?, completion: @escaping (ResolverProtocol, Any?) -> Void) {
        add(protocol: protocolType, scope: defaultScope, factory: factory, completion: completion)
    }

    func register(protocol protocolType: Protocol,
                  globalScope: ResolverGlobalScope,
                  factory: @escaping (ResolverProtocol) -> Any?,
                  completion: @escaping (ResolverProtocol, Any?) -> Void) {
        add(protocol: protocolType, scope: getGlobalScope(globalScope), factory: factory, completion: completion)
    }

    func register(protocol protocolType: Protocol,
                  scope: ResolverScopeProtocol,
                  factory: @escaping (ResolverProtocol) -> Any?,
                  completion: @escaping (ResolverProtocol, Any?) -> Void) {
        add(protocol: protocolType, scope: scope, factory: factory, completion: completion)
    }

    func register(class classType: AnyClass, factory: @escaping (ResolverProtocol) -> Any?) {
        add(class: classType, scope: defaultScope, factory: factory, completion: nil)
    }

    func register(class classType: AnyClass, globalScope: ResolverGlobalScope, factory: @escaping (ResolverProtocol) -> Any?) {
        add(class: classType, scope: getGlobalScope(globalScope), factory: factory, completion: nil)
    }

    func register(class classType: AnyClass, scope: ResolverScopeProtocol, factory: @escaping (ResolverProtocol) -> Any?) {
        add(class: classType, scope: scope, factory: factory, completion: nil)
    }

    func register(class classType: AnyClass, factory: @escaping (ResolverProtocol) -> Any?, completion: @escaping (ResolverProtocol, Any?) -> Void) {
        add(class: classType, scope: defaultScope, factory: factory, completion: completion)
    }

    func register(class classType: AnyClass,
                  globalScope: ResolverGlobalScope,
                  factory: @escaping (ResolverProtocol) -> Any?,
                  completion: @escaping (ResolverProtocol, Any?) -> Void) {
        add(class: classType, scope: getGlobalScope(globalScope), factory: factory, completion: completion)
    }

    func register(class classType: AnyClass,
                  scope: ResolverScopeProtocol,
                  factory: @escaping (ResolverProtocol) -> Any?,
                  completion: @escaping (ResolverProtocol, Any?) -> Void) {
        add(class: classType, scope: scope, factory: factory, completion: completion)
    }
}

private extension Resolver {

    // MARK: - Private functions

    func add(protocol protocolType: Protocol, scope: ResolverScopeProtocol, factory: @escaping ObjcFactory, completion: ((ResolverProtocol, Any?) -> Void)?) {
        add(protocolName: hash(protocol: protocolType), scope: scope, factory: factory, completion: completion)
    }

    func add(class classType: AnyClass, scope: ResolverScopeProtocol, factory: @escaping ObjcFactory, completion: ((ResolverProtocol, Any?) -> Void)?) {
        add(protocolName: hash(class: classType), scope: scope, factory: factory, completion: completion)
    }

    func add(protocolName: String, scope: ResolverScopeProtocol, factory: @escaping ObjcFactory, completion: ((ResolverProtocol, Any?) -> Void)?) {
        async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            if self.items.keys.contains(protocolName) {
                assert(false, "Resolver: factory for protocol \(protocolName) alreadey exist in container")
            }

            self.items[protocolName] = Item(scope: scope, instance: nil, factory: factory, completion: { resolver, resolvedObject in
                completion?(resolver, resolvedObject)
            })
        }
    }
}
