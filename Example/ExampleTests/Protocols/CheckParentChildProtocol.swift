//
//  CheckParentChildProtocol.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation

protocol CheckParentChildProtocol {

    // MARK: - Functions

    func checkParentWithChild(closure: RegisterClosure?)
    func checkOptionalStrong(closure: RegisterClosure?)
}
