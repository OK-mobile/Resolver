//
//  ParentProtocol.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation

protocol ParentProtocol: AnyObject {

    // MARK: - Properties

    var child: ChildProtocol? { get set }
    var property2: Int { get }
    var property3: String { get }
    var property4: AnyObject? { get }
}
