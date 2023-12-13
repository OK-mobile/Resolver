//
//  CheckNilResultProtocol.swift
//  ExampleTests
//
//  Created by dmitry.rybochkin on 12.03.2021.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

protocol CheckNilResultProtocol {

    // MARK: - Functions

    func checkResolveNew<T, Imp>(_ protocolType: T.Type,
                                 _ implementation: Imp.Type,
                                 closure: RegisterClosure?)
    func checkResolveSigletone<T, Imp>(_ protocolType: T.Type,
                                       _ implementation: Imp.Type,
                                       scope: ResolverScopeProtocol?,
                                       closure: RegisterClosure?)
    func checkObjcResolveNew(closure: RegisterClosure?)
    func checkObjcResolveSigletone(scope: ResolverScopeProtocol?, closure: RegisterClosure?)
    func checkResolveOptional<T, Imp>(_ protocolType: T.Type,
                                      _ implementation: Imp.Type,
                                      scope: ResolverScopeProtocol?,
                                      closure: RegisterClosure?)
    func checkObjcResolveOptional(scope: ResolverScopeProtocol?, closure: RegisterClosure?)
}
