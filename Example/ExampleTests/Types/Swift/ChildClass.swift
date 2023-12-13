//
//  ChildClass.swift
//  Resolver_Example
//
//  Created by Dmitry Rybochkin on 14/04/2019.
//  Copyright © 2019 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

final class ChildClass: ChildProtocol {

    // MARK: - Properties

    weak var parent: ParentProtocol?
    var value: Int = 0

    // MARK: - Initialization

    init() {
        parent = nil
    }

    init(value: Int) {
        parent = nil
        self.value = value
    }

    init(resolver: SwiftResolverProtocol) {
        _ = resolver.resolve(ChildProtocol.self)
        parent = nil
    }

    init?(value: String) {
        return nil
    }

    convenience init(parent: ParentProtocol?) {
        self.init()
        self.parent = parent
    }
}
