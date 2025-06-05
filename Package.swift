// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "YetiiLiib",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "YetiiLiib", targets: ["YetiiLiib"]),
    ],
    targets: [
        .target(
            name: "YetiiLiib",
            resources: [
                .process("Media.xcassets"),
                .process("Custom Cells/AppInformationTableViewCell.xib"),
            ]
        ),
    ]
)
