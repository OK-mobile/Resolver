//
//  TestObjCAsyncResolveSpec.swift
//  ExampleTests
//
//  Created by dmitry.rybochkin on 02.11.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

final class TestObjCAsyncResolveSpec: QuickSpec, CheckZeroParametersProtocol {

    // MARK: - Constants
    
    private enum Constants {
        static let attempt = 10000
    }
    
    // MARK: - Private properties

    private let scopes: [ResolverScopeProtocol] = [
        ResolverScope(referenceType: .strong, namespace: "singleScopeStrong"),
        ResolverScope(referenceType: .weak, namespace: "singleScopeWeak"),
        ResolverScope(referenceType: .none, namespace: "singleScopeNone")
    ]
    private let dispatchQueue = DispatchQueue(label: "\(TestAsyncResolveSpec.self)", attributes: .concurrent)

    // MARK: - Lifecycle

    override func spec() {
        checkDefaultScope()
        scopes.forEach({ check(scope: $0) })
        scopes.forEach({ checkObjcProtocol(scope: $0) })
        scopes.forEach({ checkObjcClass(scope: $0) })
    }
}

private extension TestObjCAsyncResolveSpec {

    // MARK: - Private functions

    func checkDefaultScope() {
        let container = register(closure: { resolver in
            resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in TestSimpleObjcClass() })
        })
        describe("these will success default scope") {
            it("async resolving") {
                var resolvedItem: TestSimpleObjcClassProtocol?
                waitUntil(timeout: .seconds(3), action: { done in
                    var iterations = 0
                    DispatchQueue.concurrentPerform(iterations: Constants.attempt, execute: { _ in
                        if resolvedItem != nil {
                            expect(container.resolve(TestSimpleObjcClassProtocol.self) === resolvedItem) == true
                        } else {
                            resolvedItem = container.resolve(TestSimpleObjcClassProtocol.self)
                        }
                        self.dispatchQueue.async(flags: .barrier, execute: {
                            iterations += 1
                            if iterations >= Constants.attempt {
                                done()
                            }
                        })
                    })
                })
            }
        }
    }
    
    func check(scope: ResolverScopeProtocol) {
        let container = register(closure: { resolver in
            resolver.register(TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in TestSimpleObjcClass() })
        })
        describe("these will success single scope \(scope.referenceType)") {
            it("async resolving") {
                waitUntil(timeout: .seconds(3), action: { done in
                    var iterations = 0
                    var resolvedItem: TestSimpleObjcClassProtocol?
                    DispatchQueue.concurrentPerform(iterations: Constants.attempt, execute: { _ in
                        switch scope.referenceType {
                        case .none: 
                            expect(container.resolve(TestSimpleObjcClassProtocol.self) !== container.resolve(TestSimpleObjcClassProtocol.self)) == true
                        case .strong, .weak:
                            if resolvedItem != nil {
                                expect(container.resolve(TestSimpleObjcClassProtocol.self) === resolvedItem) == true
                            } else {
                                resolvedItem = container.resolve(TestSimpleObjcClassProtocol.self)
                            }
                        }
                        self.dispatchQueue.async(flags: .barrier, execute: {
                            iterations += 1
                            if iterations >= Constants.attempt {
                                done()
                            }
                        })
                    })
                })
            }
        }
    }
    
    func checkObjcProtocol(scope: ResolverScopeProtocol) {
        let container = register(closure: { resolver in
            resolver.register(protocol: TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in TestSimpleObjcClass() })
        })
        describe("these will success single scope \(scope.referenceType)") {
            it("async resolving") {
                waitUntil(timeout: .seconds(3), action: { done in
                    var iterations = 0
                    var resolvedItem: TestSimpleObjcClassProtocol?
                    DispatchQueue.concurrentPerform(iterations: Constants.attempt, execute: { _ in
                        switch scope.referenceType {
                        case .none: 
                            let object1 = container.resolve(protocol: TestSimpleObjcClassProtocol.self) as? TestSimpleObjcClassProtocol
                            let object2 = container.resolve(protocol: TestSimpleObjcClassProtocol.self) as? TestSimpleObjcClassProtocol
                            expect(object1 !== object2) == true
                        case .strong, .weak:
                            if resolvedItem != nil {
                                let object = container.resolve(protocol: TestSimpleObjcClassProtocol.self) as? TestSimpleObjcClassProtocol
                                expect(object === resolvedItem) == true
                            } else {
                                resolvedItem = container.resolve(protocol: TestSimpleObjcClassProtocol.self) as? TestSimpleObjcClassProtocol
                            }
                        }
                        self.dispatchQueue.async(flags: .barrier, execute: {
                            iterations += 1
                            if iterations >= Constants.attempt {
                                done()
                            }
                        })
                    })
                })
            }
        }
    }

    func checkObjcClass(scope: ResolverScopeProtocol) {
        let container = register(closure: { resolver in
            resolver.register(class: TestSimpleObjcClass.self, scope: scope, factory: { _ in TestSimpleObjcClass() })
        })
        describe("these will success single scope \(scope.referenceType)") {
            it("async resolving") {
                waitUntil(timeout: .seconds(3), action: { done in
                    var iterations = 0
                    var resolvedItem: TestSimpleObjcClass?
                    DispatchQueue.concurrentPerform(iterations: Constants.attempt, execute: { _ in
                        switch scope.referenceType {
                        case .none: 
                            let object1 = container.resolve(class: TestSimpleObjcClass.self) as? TestSimpleObjcClass
                            let object2 = container.resolve(class: TestSimpleObjcClass.self) as? TestSimpleObjcClass
                            expect(object1 !== object2) == true
                        case .strong, .weak:
                            if resolvedItem != nil {
                                let object = container.resolve(class: TestSimpleObjcClass.self) as? TestSimpleObjcClass
                                expect(object === resolvedItem) == true
                            } else {
                                resolvedItem = container.resolve(class: TestSimpleObjcClass.self) as? TestSimpleObjcClass
                            }
                        }
                        self.dispatchQueue.async(flags: .barrier, execute: {
                            iterations += 1
                            if iterations >= Constants.attempt {
                                done()
                            }
                        })
                    })
                })
            }
        }
    }
}
