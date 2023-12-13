//
//  TestFindSpec.swift
//  ExampleTests
//
//  Created by dmitry.rybochkin on 18.11.2021.
//  Copyright © 2021 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

final class TestFindSpec: QuickSpec, CheckZeroParametersProtocol {

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
    private let dispatchQueue = DispatchQueue(label: "\(TestFindSpec.self)", attributes: .concurrent)

    // MARK: - Lifecycle

    override func spec() {
        checkDefaultScope()
        scopes.forEach({ check(scope: $0) })
    }
}

private extension TestFindSpec {

    // MARK: - Private functions
    
    func checkDefaultScope() {
        let container = register(closure: { resolver in
            resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
            resolver.register(ChildProtocol.self, factory: { _ in ChildClass() })
        })
        describe("these will success default scope") {
            it("async finding") {
                expect(container.find(ChildProtocol.self) === nil) == true
                expect(container.find(ParentProtocol.self) === nil) == true
                let parentItem: ParentProtocol? = container.resolve(ParentProtocol.self)
                expect(container.find(ParentProtocol.self) === parentItem) == true
                expect(container.find(ChildProtocol.self) === nil) == true
                waitUntil(timeout: .seconds(3), action: { done in
                    var iterations = 0
                    DispatchQueue.concurrentPerform(iterations: Constants.attempt, execute: { _ in
                        expect(container.find(ParentProtocol.self) === parentItem) == true
                        expect(container.find(ChildProtocol.self) === nil) == true
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
            resolver.register(ChildProtocol.self, factory: { _ in ChildClass() })
        })
        describe("these will success single scope \(scope.referenceType)") {
            it("async finding") {
                waitUntil(timeout: .seconds(3), action: { done in
                    var iterations = 0
                    expect(container.find(ChildProtocol.self) === nil) == true
                    expect(container.find(ParentProtocol.self) === nil) == true
                    let parentItem: ParentProtocol? = container.resolve(ParentProtocol.self)
                    expect(container.find(ChildProtocol.self) === nil) == true
                    switch scope.referenceType {
                    case .none: 
                        expect(container.find(ParentProtocol.self) == nil) == true
                    case .strong, .weak:
                        expect(container.find(ParentProtocol.self) === parentItem) == true
                    }
                    DispatchQueue.concurrentPerform(iterations: Constants.attempt, execute: { _ in
                        switch scope.referenceType {
                        case .none: 
                            expect(container.find(ChildProtocol.self) == nil) == true
                            expect(container.find(ParentProtocol.self) === nil) == true
                        case .strong, .weak:
                            expect(container.find(ChildProtocol.self) === nil) == true
                            expect(container.find(ParentProtocol.self) === parentItem) == true
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
