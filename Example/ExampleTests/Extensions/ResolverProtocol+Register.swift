//
//  ResolverProtocol+Register.swift
//  ExampleTests
//
//  Created by dmitry.rybochkin on 18.11.2021.
//  Copyright © 2021 OK.RU. All rights reserved.
//

import Foundation

import ResolverProtocol

extension ResolverProtocol {

    // MARK: - Types
    
    func register<T>(_ protocolType: T.Type, scope: ResolverScopeProtocol, factory: @escaping SwiftFactory<T>) {
        swiftResolver?.register(protocolType, scope: scope, factory: factory)
    }
    
    func unregister(scope: ResolverScopeProtocol) {
        swiftResolver?.unregister(scope: scope)
    }

    // MARK: - Private properties

    @nonobjc
    var swiftResolver: SwiftResolverProtocol? {
        if let resolver = self as? ResolverType {
            return resolver
        }
        if let resolver = self as? SwiftResolverProtocol {
            return resolver
        }
        return nil
    }
}
