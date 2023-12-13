//
//  QuickSpec+CheckZeroParametersProtocol.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import Resolver
import ResolverProtocol

extension CheckZeroParametersProtocol where Self: QuickSpec {

    // MARK: - Functions

    func register(closure: RegisterClosure?) -> ResolverProtocol {
        let resolver = Resolver(maxRecursiveDepth: 10)
        closure?(resolver)
        return resolver
    }

    func checkResolveNew<T, Imp>(_ protocolType: T.Type,
                                 _ implementation: Imp.Type,
                                 closure: RegisterClosure?) {
        it("test register/resolve new zero parameters") {
            let resolver = self.register(closure: closure)
            guard let parent1: T = resolver.resolveNew() else {
                expect("resolve") == "fail"
                return
            }
            guard let parent2 = resolver.resolveNew(T.self) else {
                expect("resolve") == "fail"
                return
            }
            expect(parent1 as AnyObject === parent2 as AnyObject) == false
            guard let equalParent1 = parent1 as? Imp else {
                expect("cast to \(Imp.self)") == "fail"
                return
            }
            guard let equalParent2 = parent2 as? Imp else {
                expect("cast to \(Imp.self)") == "fail"
                return
            }
            expect(equalParent1 as AnyObject === equalParent2 as AnyObject) == false
        }
    }

    func checkResolveSigletone<T, Imp>(_ protocolType: T.Type,
                                       _ implementation: Imp.Type,
                                       scope: ResolverScopeProtocol?,
                                       closure: RegisterClosure?) {
        it("test register/resolve singletone zero parameters") {
            let resolver = self.register(closure: closure)
            guard let parent1: T = resolver.resolve() else {
                expect("resolve") == "fail"
                return
            }
            guard let parent2 = resolver.resolve(T.self) else {
                expect("resolve") == "fail"
                return
            }
            var needSuccess = true
            if let scope = scope {
                needSuccess = scope.referenceType != .none
            }
            expect(parent1 as AnyObject === parent2 as AnyObject) == needSuccess
            guard let equalParent1 = parent1 as? Imp else {
                expect("cast to \(Imp.self)") == "fail"
                return
            }
            guard let equalParent2 = parent2 as? Imp else {
                expect("cast to \(Imp.self)") == "fail"
                return
            }
            expect(equalParent1 as AnyObject === equalParent2 as AnyObject) == needSuccess
        }
    }

    func checkObjcResolveNew(closure: RegisterClosure?) {
        it("test objc register/resolve new zero parameters") {
            let resolver = self.register(closure: closure)
            guard let object1 = resolver.resolveNew(TestObjcClassProtocol.self)?.childObject else {
                expect("resolve") == "fail"
                return
            }
            guard let object2 = resolver.resolveNew(TestObjcClassProtocol.self)?.childObject else {
                expect("resolve") == "fail"
                return
            }
            expect(object1 === object2) == false
            guard let equalObject1 = object1 as? TestSimpleObjcClass else {
                expect("cast to \(TestSimpleObjcClass.self)") == "fail"
                return
            }
            guard let equalObject2 = object2 as? TestSimpleObjcClass else {
                expect("cast to \(TestSimpleObjcClass.self)") == "fail"
                return
            }
            expect(equalObject1 === equalObject2) == false
        }
    }

    func checkObjcResolveSigletone(scope: ResolverScopeProtocol?, closure: RegisterClosure?) {
        it("test objc register/resolve singletone zero parameters") {
            let resolver = self.register(closure: closure)
            guard let object1 = resolver.resolveNew(TestObjcClassProtocol.self)?.childObject else {
                expect("resolve") == "fail"
                return
            }
            guard let object2 = resolver.resolveNew(TestObjcClassProtocol.self)?.childObject else {
                expect("resolve") == "fail"
                return
            }
            var needSuccess = true
            if let scope = scope {
                needSuccess = scope.referenceType != .none
            }
            expect(object1 === object2) == needSuccess
            guard let equalObject1 = object1 as? TestSimpleObjcClass else {
                expect("cast to \(TestSimpleObjcClass.self)") == "fail"
                return
            }
            guard let equalObject2 = object2 as? TestSimpleObjcClass else {
                expect("cast to \(TestSimpleObjcClass.self)") == "fail"
                return
            }
            expect(equalObject1 === equalObject2) == needSuccess
        }
    }

    func checkResolveOptional<T, Imp>(_ protocolType: T.Type,
                                      _ implementation: Imp.Type,
                                      scope: ResolverScopeProtocol?,
                                      closure: RegisterClosure?) {
        it("test objc register/resolve optional zero parameters") {
            let resolver = self.register(closure: closure)
            
            let optionalParentNew: T? = resolver.resolveNew()!
            expect(optionalParentNew != nil) == true

            let optionalParent: T? = resolver.resolve()!
            expect(optionalParent != nil) == true
        }
    }
    
    func checkObjcResolveOptional(scope: ResolverScopeProtocol?, closure: RegisterClosure?) {
        it("test objc register/resolve optional zero parameters") {
            let resolver = self.register(closure: closure)
            let optionalParentNew: TestObjcClassProtocol? = resolver.resolveNew()!
            expect(optionalParentNew != nil) == true

            let optionalParent: TestObjcClassProtocol? = resolver.resolve()!
            expect(optionalParent != nil) == true
        }
    }
    
    func checkObjcResolveNewAsObjcProtocol(closure: RegisterClosure?) {
        it("test objc protocol register/resolve new zero parameters") {
            let resolver = self.register(closure: closure)
            guard let object1 = resolver.resolveNew(protocol: TestObjcClassProtocol.self) as? TestObjcClassProtocol else {
                expect("resolve") == "fail"
                return
            }
            guard let object2 = resolver.resolveNew(protocol: TestObjcClassProtocol.self) as? TestObjcClassProtocol else {
                expect("resolve") == "fail"
                return
            }

            if object1.childObject == nil, object2.childObject == nil {
                expect(true) == true
                return
            }

            expect(object1.childObject === object2.childObject) == false
            guard let equalObject1 = object1.childObject as? TestSimpleObjcClass else {
                expect("cast to \(TestSimpleObjcClass.self)") == "fail"
                return
            }
            guard let equalObject2 = object2.childObject as? TestSimpleObjcClass else {
                expect("cast to \(TestSimpleObjcClass.self)") == "fail"
                return
            }
            expect(equalObject1 === equalObject2) == false
        }
    }
    
    func checkObjcResolveNewAsObjcClass(closure: RegisterClosure?) {
        it("test objc class register/resolve new zero parameters") {
            let resolver = self.register(closure: closure)
            guard let object1 = resolver.resolveNew(class: TestObjcClass.self) as? TestObjcClass else {
                expect("resolve") == "fail"
                return
            }
            guard let object2 = resolver.resolveNew(class: TestObjcClass.self) as? TestObjcClass else {
                expect("resolve") == "fail"
                return
            }
            expect(object1 === object2) == false
            if object1.childObject == nil, object2.childObject == nil {
                expect(true) == true
            } else {
                expect(object1.childObject === object2.childObject) == false
            }
        }
    }
    
    func checkObjcResolveSigletoneAsObjcProtocol(scope1: ResolverScopeProtocol?, scope2: ResolverScopeProtocol?, closure: RegisterClosure?) {
        it("test objc protocol register/resolve singletone zero parameters") {
            let resolver = self.register(closure: closure)
            guard let object1 = resolver.resolve(protocol: TestObjcClassProtocol.self) as? TestObjcClassProtocol else {
                expect("resolve") == "fail"
                return
            }
            guard let object2 = resolver.resolve(protocol: TestObjcClassProtocol.self) as? TestObjcClassProtocol else {
                expect("resolve") == "fail"
                return
            }
            var needSuccess = true
            if let scope = scope2 {
                needSuccess = scope.referenceType != .none
            }
            expect(object1 === object2) == needSuccess
            if object1.childObject == nil, object2.childObject == nil {
                expect(true) == true
                return
            }
            guard let equalObject1 = object1.childObject as? TestSimpleObjcClass else {
                expect("cast to \(TestSimpleObjcClass.self)") == "fail"
                return
            }
            guard let equalObject2 = object2.childObject as? TestSimpleObjcClass else {
                expect("cast to \(TestSimpleObjcClass.self)") == "fail"
                return
            }
            if let scope1 = scope1, let scope2 = scope2 {
                needSuccess = scope1.referenceType != .none || scope2.referenceType != .none
            }
            expect(equalObject1 === equalObject2) == needSuccess
        }
    }

    func checkObjcResolveSigletoneAsObjClass(scope1: ResolverScopeProtocol?, scope2: ResolverScopeProtocol?, closure: RegisterClosure?) {
        it("test objc class register/resolve singletone zero parameters") {
            let resolver = self.register(closure: closure)
            guard let object1 = resolver.resolve(class: TestObjcClass.self) as? TestObjcClass else {
                expect("resolve") == "fail"
                return
            }
            guard let object2 = resolver.resolve(class: TestObjcClass.self) as? TestObjcClass else {
                expect("resolve") == "fail"
                return
            }
            var needSuccess = true
            if let scope = scope2 {
                needSuccess = scope.referenceType != .none
            }
            expect(object1 === object2) == needSuccess
            if object1.childObject == nil, object2.childObject == nil {
                expect(true) == true
                return
            }
            guard let equalObject1 = object1.childObject as? TestSimpleObjcClass else {
                expect("cast to \(TestSimpleObjcClass.self)") == "fail"
                return
            }
            guard let equalObject2 = object2.childObject as? TestSimpleObjcClass else {
                expect("cast to \(TestSimpleObjcClass.self)") == "fail"
                return
            }
            if let scope1 = scope1, let scope2 = scope2 {
                needSuccess = scope1.referenceType != .none || scope2.referenceType != .none
            }
            expect(equalObject1 === equalObject2) == needSuccess
        }
    }
}
