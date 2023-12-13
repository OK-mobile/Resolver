//
//  ViewController.swift
//  Example
//
//  Created by dmitry.rybochkin on 31.08.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Resolver
import ResolverProtocol
import UIKit

final class ViewController: UIViewController {

    // MARK: - Properties
    
    let resolver: ResolverType = Resolver(maxRecursiveDepth: 10)
    var objcRegistration: ObjcResolverRegistration?

    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        objcRegistration = ObjcResolverRegistration(resolver: resolver)
        
        resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            print(String(describing: self.resolver.resolve(ParentProtocol.self)))
            print("object resolved")
            print(String(describing: self.resolver.resolve(TestObjcClassProtocol.self)))
            print("object resolved")
        })
        
        resolver.subscribe(self, type: ParentProtocol.self, event: { object in
            guard let object = object else {
                return
            }
            print("notification received")
            print(String(describing: object))
        })

        resolver.subscribe(self, type: TestObjcClassProtocol.self, event: { object in
            guard let object = object else {
                return
            }
            print("notification received")
            print(String(describing: object))
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            print(String(describing: self.resolver.resolve(ParentProtocol.self)))
            print("object resolved second")
            self.resolver.releaseInstance(TestObjcClassProtocol.self)
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: {
            self.resolver.unsubscribe(self, type: ParentProtocol.self)
            if let objcRegistration = self.objcRegistration {
                self.resolver.unsubscribeAll(objcRegistration)
            }
            print("unsubscribe")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
            print("unsubscribe \(self.resolver)")
        })
   }
}
