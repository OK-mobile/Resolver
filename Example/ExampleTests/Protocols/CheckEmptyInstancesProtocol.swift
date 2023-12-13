//
//  CheckEmptyInstancesProtocol.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation

protocol CheckEmptyInstancesProtocol {

    // MARK: - Functions

    func checkEmptyInstances(scopes: [ResolverScopeProtocol], useNamespace: Bool, closure: RegisterClosure?)
    func checkEmptyInstancesByTypes(scopes: [ResolverScopeProtocol], closure: RegisterClosure?)
    func checkEmptyInstancesWithCompletionByTypes(scopes: [ResolverScopeProtocol], closure: RegisterClosure?)
}
