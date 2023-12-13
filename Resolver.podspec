Pod::Spec.new do |s|
    s.name             = 'Resolver'
    s.version          = '0.1.0'
    s.summary          = 'A short description of Resolver.'
    s.homepage         = "https://stash.odkl.ru/projects/IOS/repos/odnoklassniki-ios/browse"
    s.author           = { 'Dmitry Rybochkin' => 'dmitry.rybochkin@corp.mail.ru' }
    s.source           = { :path => "." }
    s.ios.deployment_target = '12.0'
    s.swift_version = '5.2'
    s.platform = :ios, '12.0'

    s.prefix_header_file = false
    s.source_files  = 'Classes/**/*.{h,m,swift}'

    s.frameworks = 'Foundation', 'QuartzCore'

    s.dependency 'ResolverProtocol'
end
