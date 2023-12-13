//
//  Resolver+Subscriber.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 26.05.2021.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

public extension Resolver {

    final class Subscriber {

        // MARK: - Private properties

        private let event: SwiftSubscribeEvent<Any>

        // MARK: - Properties

        weak var subscriber: AnyObject?
        weak var instance: AnyObject?

        // MARK: - Initialization

        init(subscriber: AnyObject, event: @escaping SwiftSubscribeEvent<Any>, instance: AnyObject?) {
            self.subscriber = subscriber
            self.event = event
            if instance != nil {
                notify(instance: instance)
            }
        }

        // MARK: - Functions

        func notify(instance: AnyObject?) {
            if instance !== self.instance {
                self.instance = instance
                event(instance)
            }
        }
    }
}
