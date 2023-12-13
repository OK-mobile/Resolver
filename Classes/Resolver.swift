//
//  Resolver.swift
//  Odnoklassniki
//
//  Created by dmitry.rybochkin on 16.02.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Foundation
import ResolverProtocol

@objcMembers
public final class Resolver: NSObject, ResolverProtocol, SwiftResolverProtocol {

    // MARK: - Constants

    private enum Constants {
        static let maxRecursiveDepth = 10
        static let separator = "."
    }

    // MARK: - Public properties

    public var logger: ResolverLoggerProtocol?

    // MARK: - Properties

    var items: [AnyHashable: Item]
    var subscribers: [AnyHashable: [Subscriber]]
    private(set) var maxRecursiveDepth: Int
    var currentRecursiveDepth: Int
    var subscribeDispatchQueue: DispatchQueue

    // MARK: - Private properties

    private var dispatchQueue: DispatchQueue
    private var mutex = pthread_mutex_t()
    private let key = DispatchSpecificKey<QueueReference>()

    // MARK: - Global Scopes

    lazy var defaultScope: ResolverScopeProtocol = ResolverScope(referenceType: .strong, namespace: "default")
    lazy var sessionScope: ResolverScopeProtocol = ResolverScope(referenceType: .strong, namespace: "session")
    lazy var transientScope: ResolverScopeProtocol = ResolverScope(referenceType: .none, namespace: "transient")

    // MARK: - Initialization

    public override init() {
        let queueLabel = "\(Resolver.self).\(DispatchQueue.self).\(UUID().uuidString)"
        dispatchQueue = DispatchQueue(label: queueLabel, attributes: .concurrent)
        self.currentRecursiveDepth = 0
        self.maxRecursiveDepth = Constants.maxRecursiveDepth
        items = [:]
        subscribeDispatchQueue = DispatchQueue(label: "\(Resolver.self).subscribeDispatchQueue", attributes: .concurrent)
        subscribers = [:]
        super.init()
        configure()
    }

    public convenience init(logger: ResolverLoggerProtocol) {
        self.init()
        self.logger = logger
    }

    public convenience init(maxRecursiveDepth: Int) {
        self.init()
        self.maxRecursiveDepth = maxRecursiveDepth
    }

    public convenience init(logger: ResolverLoggerProtocol, maxRecursiveDepth: Int) {
        self.init()
        self.logger = logger
        self.maxRecursiveDepth = maxRecursiveDepth
    }

    // MARK: - Functions

    func hash<T>(_ protocolType: T.Type) -> String {
        if let value = protocolType.self as? OptionalProtocol.Type {
            return hash(protocolName: String(describing: value.wrappedType()))
        }
        return hash(protocolName: String(describing: T.self))
    }

    func hash(protocol protocolType: Protocol) -> String {
        return hash(protocolName: NSStringFromProtocol(protocolType))
    }

    func hash(class classType: AnyClass) -> String {
        return hash(protocolName: NSStringFromClass(classType))
    }

    func async(flags: DispatchWorkItemFlags = [], execute work: @escaping () -> Void) {
        pthread_mutex_lock(&mutex)
        defer { pthread_mutex_unlock(&mutex) }
        work()
    }

    func sync<T>(execute work: () -> T) -> T {
        pthread_mutex_lock(&mutex)
        defer { pthread_mutex_unlock(&mutex) }
        return work()
    }

    func getGlobalScope(_ scope: ResolverGlobalScope) -> ResolverScopeProtocol {
        switch scope {
        case .default:
            return defaultScope
        case .session:
            return sessionScope
        case .transient:
            return transientScope
        }
    }
}

private extension Resolver {

    // MARK: - Private types

    struct QueueReference {
        weak var queue: DispatchQueue?
    }

    // MARK: - Private functions

    func hash(protocolName: String) -> String {
        #if DEBUG && !AUTOTEST
        let parts = protocolName.components(separatedBy: Constants.separator)
        /*
         В случае ассерта нужно добавить @objc(имя класса или протокола) к декларации, если не поможет написать ответсвенному за модуль
         */
        assert(parts.count == 1, "Resolver: protocol \(protocolName) has prefix")
        if let lastPart = parts.last {
            return lastPart
        }
        #endif
        return protocolName
    }

    func configure() {
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attr)
        dispatchQueue.setSpecific(key: key, value: QueueReference(queue: dispatchQueue))
    }
}
