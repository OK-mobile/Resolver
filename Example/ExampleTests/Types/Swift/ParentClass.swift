//
//  ParentClass.swift
//  Resolver_Example
//
//  Created by Dmitry Rybochkin on 14/04/2019.
//  Copyright © 2019 OK.RU. All rights reserved.
//

import Foundation

final class ParentClass: ParentProtocol {

    // MARK: - Properties

    var child: ChildProtocol?
    var property2: Int
    var property3: String
    var property4: AnyObject?

    // MARK: - Initialization

    init() {
        self.child = nil
        self.property2 = 0
        self.property3 = ""
        self.property4 = nil
    }

    convenience init(property1: ChildProtocol?) {
        self.init()
        self.child = property1
    }

    convenience init(property1: ChildProtocol?, property2: Int) {
        self.init()
        self.child = property1
        self.property2 = property2
    }

    convenience init(property3: String, property4: AnyObject?) {
        self.init()
        self.property3 = property3
        self.property4 = property4
    }

    convenience init(property2: Int, property3: String, property4: AnyObject?) {
        self.init()
        self.property2 = property2
        self.property3 = property3
        self.property4 = property4
    }
}

extension ParentClass: Equatable {

    // MARK: - Functions

    static func == (lhs: ParentClass, rhs: ParentClass) -> Bool {
        return lhs.child === rhs.child &&
            lhs.property2 == rhs.property2 &&
            lhs.property3 == rhs.property3
    }
}
