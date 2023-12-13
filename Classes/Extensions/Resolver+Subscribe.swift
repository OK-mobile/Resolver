//
//  Resolver+Subscribe.swift
//  Resolver
//
//  Created by dmitry.rybochkin on 26.05.2021.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

public extension Resolver {

    // MARK: - Functions

    func subscribe(_ subscriber: AnyObject, protocol protocolType: Protocol, event: @escaping ObjcSubscribeEvent) {
        subscribe(subscriber, protocolName: hash(protocol: protocolType), event: event)
    }

    func subscribe(_ subscriber: AnyObject, class classType: AnyClass, event: @escaping ObjcSubscribeEvent) {
        subscribe(subscriber, protocolName: hash(class: classType), event: event)
    }

    func unsubscribe(_ subscriber: AnyObject, protocol protocolType: Protocol) {
        unsubscribe(subscriber, protocolName: hash(protocol: protocolType))
    }

    func unsubscribe(_ subscriber: AnyObject, class classType: AnyClass) {
        unsubscribe(subscriber, protocolName: hash(class: classType))
    }

    func unsubscribeAll(_ subscriber: AnyObject) {
        unsubscribe(subscriber, protocolName: nil)
    }

    func subscribe<T>(_ subscriber: AnyObject, type protocolType: T.Type, event: @escaping SwiftSubscribeEvent<T>) {
        subscribe(subscriber, protocolName: hash(T.self), event: { object in
            event(object as? T)
        })
    }

    func unsubscribe<T>(_ subscriber: AnyObject, type protocolType: T.Type) {
        unsubscribe(subscriber, protocolName: hash(T.self))
    }

    func notifySubscribers(protocolName: AnyHashable, instance: Any?) {
        var objectInstance: AnyObject?
        if let instance = instance {
            objectInstance = instance as AnyObject
        }
        subscribeDispatchQueue.async { [weak self, weak objectInstance] in
            self?.subscribers[protocolName]?.forEach { $0.notify(instance: objectInstance) }
        }
    }
}

private extension Resolver {

    // MARK: - Private properties

    func subscribe(_ subscriber: AnyObject, protocolName: String, event: @escaping ObjcSubscribeEvent) {
        subscribeDispatchQueue.async(flags: .barrier) { [weak self, weak subscriber] in
            guard let self = self, let subscriber = subscriber else {
                return
            }
            self.clearSubscribers()
            var currentSubscribers = self.subscribers[protocolName] ?? []
            let instance = self.sync { self.items[protocolName]?.instance }
            if let currentSubscriber = currentSubscribers.first(where: { $0.subscriber === subscriber }) {
                currentSubscriber.notify(instance: instance)
            } else {
                currentSubscribers.append(Subscriber(subscriber: subscriber, event: event, instance: instance))
                self.subscribers[protocolName] = currentSubscribers
            }
        }
    }

    func unsubscribe(_ subscriber: AnyObject, protocolName: AnyHashable?) {
        subscribeDispatchQueue.async(flags: .barrier) { [weak self, weak subscriber] in
            guard let self = self else {
                return
            }
            if let protocolName = protocolName {
                self.subscribers[protocolName] = self.subscribers[protocolName]?.filter { $0.subscriber !== subscriber } ?? []
            } else {
                self.subscribers.forEach { self.subscribers[$0.key] = $0.value.filter { $0.subscriber !== subscriber } }
            }
            self.clearSubscribers()
        }
    }

    func clearSubscribers() {
        subscribers.forEach { subscribers[$0.key] = $0.value.filter { $0.subscriber != nil } }
        subscribers = subscribers.filter { !$0.value.isEmpty }
    }
}
