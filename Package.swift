// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "YetiiLiib",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "YetiiLiib", targets: ["YetiiLiib"]),
    ],
    targets: [
        .target(
            name: "YetiiLiib",
            resources: [
                .process("Media.xcassets"),
                .process("AppInformationTableViewCell.xib"),
            ]
        ),
    ]
)
