// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

var dependenciesProducts: [PackageDescription.Product] = [
    .library(name: "AppInfo", targets: ["AppInfo"]),
    .library(name: "AuthProvider", targets: ["AuthProvider"]),
    .library(name: "ErrorMapper", targets: ["ErrorMapper"]),
    .library(name: "Logger", targets: ["Logger"]),
]

var dependenciesTargets: [PackageDescription.Target] = [
    .target(
        name: "AppInfo",
        dependencies: [
        ],
        path: "Sources/Dependencies/AppInfo",
        swiftSettings: [.define("PRODUCTION", .when(configuration: .release))]
    ),
    .target(
        name: "AuthProvider",
        dependencies: [
            "ErrorMapper",
            "Logger",
        ],
        path: "Sources/Dependencies/AuthProvider"
    ),
    .target(
        name: "ErrorMapper",
        dependencies: [
        ],
        path: "Sources/Dependencies/ErrorMapper"
    ),
    .target(
        name: "Logger",
        dependencies: [
        ],
        path: "Sources/Dependencies/Logger"
    ),
]

var featuresProducts: [PackageDescription.Product] = [
    .library(name: "Authentication", targets: ["Authentication"]),
]

var featuresTargets: [PackageDescription.Target] = [
    .target(
        name: "Authentication",
        dependencies: [
            "AppInfo",
            "AuthProvider",
            "UIComponents",
            .product(name: "Lottie", package: "lottie-spm"),
        ],
        path: "Sources/Features/Authentication",
        swiftSettings: [.define("PRODUCTION", .when(configuration: .release))]
    ),
]

// MARK: - Additional
var additionalProducts: [PackageDescription.Product] = [
    .library(name: "Design", targets: ["Design"]),
    .library(name: "UIComponents", targets: ["UIComponents"]),
]

var additionalTargets: [PackageDescription.Target] = [
    .target(
        name: "Design",
        dependencies: [
        ],
        path: "Sources/Generated/Design",
        resources: [
            .process("Resources"),
        ]
    ),
    .target(
        name: "UIComponents",
        dependencies: [
            "Design",
        ],
        path: "Sources/UIComponents"
    ),
]

// MARK: - Tests
var testTargets: [PackageDescription.Target] = [
    .testTarget(
        name: "ModulesTests",
        dependencies:
        dependenciesProducts.map { .byNameItem(name: $0.name, condition: nil) } +
            featuresProducts.map { .byNameItem(name: $0.name, condition: nil) },

        path: "Tests",
        resources: [
        ]
    ),
]

// MARK: - Package
let package = Package(
    name: "modules",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
    ],
    products: dependenciesProducts + featuresProducts + additionalProducts,
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm", from: "4.5.0"),
    ],
    targets: dependenciesTargets + featuresTargets + additionalTargets + testTargets
)
