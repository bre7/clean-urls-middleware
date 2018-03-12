// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "CleanUrlsMiddleware",
    products: [
    	.library(name: "CleanUrlsMiddleware", targets: ["CleanUrlsMiddleware"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc.1.1"),
    ],
    targets: [
    	.target(name: "CleanUrlsMiddleware", dependencies: ["Vapor"]),
    ]
)