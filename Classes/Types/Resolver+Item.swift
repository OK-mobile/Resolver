//
//  Resolver+Item.swift
//  Odnoklassniki
//
//  Created by dmitry.rybochkin on 19.02.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

public extension Resolver {

    final class Item {

        // MARK: - Properties

        var scope: ResolverScopeProtocol
        var factory: SwiftFactory<Any>
        var completion: SwiftCompletion<Any>?
        var instance: AnyObject? {
            get {
                return getInstance()
            }
            set {
                set(instance: newValue)
            }
        }

        // MARK: - Private properties

        private weak var weakInstance: AnyObject?
        private var strongInstance: AnyObject?

        // MARK: - Initialization

        init(scope: ResolverScopeProtocol, instance: AnyObject?, factory: @escaping SwiftFactory<Any>, completion: SwiftCompletion<Any>?) {
            self.factory = factory
            self.scope = scope
            self.instance = instance
            switch scope.referenceType {
            case .none:
                // Из-за бесконечной рекурсии, нужно добавить отдельное хранилище ссылок на объекты для дерева одной рекурсии .none
                self.completion = nil
            case .strong, .weak:
                self.completion = completion
            }
        }
    }
}

private extension Resolver.Item {

    // MARK: - Private functions

    func getInstance() -> AnyObject? {
        switch scope.referenceType {
        case .none:
            return nil
        case .strong:
            return strongInstance
        case .weak:
            return weakInstance
        }
    }

    func set(instance: AnyObject?) {
        switch scope.referenceType {
        case .none:
            break
        case .strong:
            strongInstance = instance
        case .weak:
            weakInstance = instance
        }
    }
}
