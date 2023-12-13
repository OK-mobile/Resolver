let package = Package(
    name: "Resolver",
    defaultLocalization: "en",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "Resolver",
            targets: ["Resolver"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Resolver",
            dependencies: [
                "ResolverProtocol"
            ],
            path: "Classes"
        ),
    ]
)
