//
//  TestAsyncResolveSpec.swift
//  ExampleTests
//
//  Created by dmitry.rybochkin on 02.11.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

final class TestAsyncResolveSpec: QuickSpec, CheckZeroParametersProtocol {

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
    }
}

private extension TestAsyncResolveSpec {

    // MARK: - Private functions
    
    func checkDefaultScope() {
        let container = register(closure: { resolver in
            resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
        })
        describe("these will success default scope") {
            it("async resolving") {
                var resolvedItem: ParentProtocol?
                waitUntil(timeout: .seconds(3), action: { done in
                    var iterations = 0
                    DispatchQueue.concurrentPerform(iterations: Constants.attempt, execute: { _ in
                        if resolvedItem != nil {
                            expect(container.resolve(ParentProtocol.self) === resolvedItem) == true
                        } else {
                            resolvedItem = container.resolve(ParentProtocol.self)
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
            resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
        })
        describe("these will success single scope \(scope.referenceType)") {
            it("async resolving") {
                waitUntil(timeout: .seconds(3), action: { done in
                    var iterations = 0
                    var resolvedItem: ParentProtocol?
                    DispatchQueue.concurrentPerform(iterations: Constants.attempt, execute: { _ in
                        switch scope.referenceType {
                        case .none: 
                            expect(container.resolve(ParentProtocol.self) !== container.resolve(ParentProtocol.self)) == true
                        case .strong, .weak:
                            if resolvedItem != nil {
                                expect(container.resolve(ParentProtocol.self) === resolvedItem) == true
                            } else {
                                resolvedItem = container.resolve(ParentProtocol.self)
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
