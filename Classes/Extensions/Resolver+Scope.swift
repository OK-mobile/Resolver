//
//  Resolver+Scope.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

extension Resolver {

    @objc
    final class ResolverScope: NSObject, ResolverScopeProtocol {

        // MARK: - Properties

        var referenceType: ResolverReferenceType
        var namespace: String

        // MARK: - Initialization

        init(referenceType: ResolverReferenceType, namespace: String) {
            self.referenceType = referenceType
            self.namespace = namespace
            super.init()
        }
    }
}
