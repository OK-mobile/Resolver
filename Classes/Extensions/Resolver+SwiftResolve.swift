//
//  Resolver+SwiftResolve.swift
//  Odnoklassniki
//
//  Created by dmitry.rybochkin on 19.02.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import QuartzCore
import ResolverProtocol

public extension Resolver {

    // MARK: - Functions

    func resolve<T>() -> T? {
        resolve(protocolType: T.self, isSingletone: true)
    }

    func resolve<T>(_ protocolType: T.Type) -> T? {
        resolve(protocolType: protocolType, isSingletone: true)
    }

    func resolveNew<T>(_ protocolType: T.Type) -> T? {
        resolve(protocolType: protocolType, isSingletone: false)
    }

    func resolveNew<T>() -> T? {
        resolve(protocolType: T.self, isSingletone: false)
    }

    func find<T>(_ protocolType: T.Type) -> T? {
        find(protocolType: protocolType)
    }

    func find<T>() -> T? {
        find(protocolType: T.self)
    }

    func resolveObjC(protocol protocolType: Protocol, isSingletone: Bool) -> Any? {
        let protocolName = hash(protocol: protocolType)
        return resolve(protocolName: protocolName, isSingletone: isSingletone, onlyFind: false)
    }

    func resolveObjC(class classType: AnyClass, isSingletone: Bool) -> Any? {
        let protocolName = hash(class: classType)
        return resolve(protocolName: protocolName, isSingletone: isSingletone, onlyFind: false)
    }

    func findObjC(protocol protocolType: Protocol) -> Any? {
        let protocolName = hash(protocol: protocolType)
        return resolve(protocolName: protocolName, isSingletone: false, onlyFind: true)
    }

    func findObjC(class classType: AnyClass) -> Any? {
        let protocolName = hash(class: classType)
        return resolve(protocolName: protocolName, isSingletone: false, onlyFind: true)
    }
}

private extension Resolver {

    // MARK: - Constants

    private enum Constants {
        static let milliseconds: CFTimeInterval = 1000
    }

    // MARK: - Private functions

    func writeLog(protocolName: String,
                  startMediaTime: CFTimeInterval,
                  finishFindMediaTime: CFTimeInterval) {
//        guard let logger = logger else {
//            return
//        }
//        let resolveDuration = (CACurrentMediaTime() - startMediaTime) * Constants.milliseconds
//        // let findingDuration = (finishFindMediaTime - startMediaTime) * Constants.milliseconds
//        let logString = String(format: "🔱 %.2fms %@", resolveDuration, protocolName)
//
//        //let logString = "RESOLVER: created \(protocolName) duration = \(resolveDuration) ms" // instance for | find = \(findingDuration) ms
//        logger.write(message: logString)
    }

    func resolve(protocolName: String, isSingletone: Bool, onlyFind: Bool) -> Any? {
        let startMediaTime = CACurrentMediaTime()
        guard let item = find(protocolName: protocolName, onlyFind: onlyFind) else {
            return nil
        }
        if onlyFind {
            return item.instance
        }
        let finishFindMediaTime = CACurrentMediaTime()
        if !isSingletone || item.scope.referenceType == .none {
            let instance = getFactory(protocolName: protocolName, item: item)?(self)
            notifySubscribers(protocolName: protocolName, instance: instance)
            return instance
        }
        if isSingletone, let instance = item.instance, item.instance != nil {
            return instance
        }
        increaseDepth()
        let instance: Any? = sync {
            guard let factory = getFactory(protocolName: protocolName, item: item) else {
                return nil
            }
            var instance = factory(self)
            if isSingletone {
                instance = set(instance: instance, item: item)
            }
            if let completion = item.completion {
                completion(self, instance)
            }
            return instance
        }
        decreaseDepth()
        writeLog(protocolName: protocolName,
                 startMediaTime: startMediaTime,
                 finishFindMediaTime: finishFindMediaTime)
        notifySubscribers(protocolName: protocolName, instance: instance)
        return instance
    }

    @nonobjc
    func resolve<T>(protocolType: T.Type, isSingletone: Bool) -> T? {
        let protocolName = hash(T.self)
        return resolve(protocolName: protocolName, isSingletone: isSingletone, onlyFind: false) as? T
    }

    @nonobjc
    func find<T>(protocolType: T.Type) -> T? {
        let protocolName = hash(T.self)
        return resolve(protocolName: protocolName, isSingletone: false, onlyFind: true) as? T
    }

    func getFactory(protocolName: String, item: Item) -> SwiftFactory<Any>? {
        let factory: SwiftFactory<Any>? = item.factory
        if factory == nil {
            assert(false, "Resolver: factory for protocol \(protocolName) is nil")
        }
        return factory
    }

    func find(protocolName: String, onlyFind: Bool = false) -> Item? {
        var result: Item?
        sync { [weak self] in
            guard let self = self else {
                return
            }
            result = self.items[protocolName]
        }
        if result == nil, !onlyFind {
            fatalError("Resolver: factory for protocol \(protocolName) not found in container")
        }
        return result
    }

    func set(instance: Any?, item: Item) -> Any? {
        switch item.scope.referenceType {
        case .none:
            return instance
        case .strong, .weak:
            guard let instance = item.instance ?? instance else {
                return nil
            }
            item.instance = instance as AnyObject
            return instance
        }
    }

    func increaseDepth() {
        async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            if self.currentRecursiveDepth > self.maxRecursiveDepth {
                assert(false, "Resolver: potential recursive resolving current depth = \(self.currentRecursiveDepth) max depth \(self.maxRecursiveDepth)")
            }
            self.currentRecursiveDepth += 1
        }
    }

    func decreaseDepth() {
        async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            self.currentRecursiveDepth -= 1
        }
    }
}
