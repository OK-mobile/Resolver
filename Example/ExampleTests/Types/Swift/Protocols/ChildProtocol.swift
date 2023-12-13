//
//  ChildProtocol.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation

protocol ChildProtocol: AnyObject {

    // MARK: - Properties

    var parent: ParentProtocol? { get set }
    var value: Int { get }
}
