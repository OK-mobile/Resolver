Pod::Spec.new do |s|
    s.name             = 'Resolver'
    s.version          = '0.1.0'
    s.summary          = 'A short description of Resolver.'
    s.homepage         = "https://stash.odkl.ru/projects/IOS/repos/odnoklassniki-ios/browse"
    s.author           = { 'Dmitry Rybochkin' => 'dmitry.rybochkin@corp.mail.ru' }
    s.source           = { :git => 'https://github.com/OK-mobile/Resolver.git', :tag => '0.1.0' }
    s.ios.deployment_target = '12.0'
    s.swift_version = '5.2'
    s.platform = :ios, '12.0'

    s.prefix_header_file = false
    s.source_files  = 'Classes/**/*.{h,m,swift}'

    s.frameworks = 'Foundation', 'QuartzCore'

    s.dependency 'ResolverProtocol'

    s.app_spec 'Example' do |app_spec|
      app_spec.source_files = [
        'Example/Example/**/*.{h,m,swift}',
        'Example/ExampleTests/Types/ObjC/TestObjcClass.m',
        'Example/ExampleTests/Types/ObjC/TestSimpleObjcClass.m',
        'Example/ExampleTests/Types/Swift/ChildClass.swift',
        'Example/ExampleTests/Types/Swift/ParentClass.swift',
        'Example/ExampleTests/Types/Swift/ServiceLocatorScope.swift',
        'Example/ExampleTests/Types/Swift/Protocols/ChildProtocol.swift',
        'Example/ExampleTests/Types/Swift/Protocols/ParentProtocol.swift'
      ]
      #app_spec.info_plist = 'Example/Example/Info.plist'
      app_spec.xcconfig = { 'SWIFT_OBJC_BRIDGING_HEADER' => '${PODS_TARGET_SRCROOT}/Example/Example/Example-Bridging-Header.h' }
    end

    s.test_spec 'Tests' do |test_spec|
      test_spec.requires_app_host = true
      test_spec.source_files = 'Example/ExampleTests/**/*.{h,swift}'
      test_spec.app_host_name = 'Resolver/Example'

      test_spec.dependency 'Resolver/Example'
      test_spec.dependency 'Quick', '5.0.1'
      test_spec.dependency 'Nimble', '10.0.0'
    end
end
