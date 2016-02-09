
import PackageDescription

let package = Package(
    name: "CS81",
    dependencies: [
        .Package(url: "https://github.com/JadenGeller/Axiomatic.git", majorVersion: 1),
        .Package(url: "https://github.com/JadenGeller/Parsley.git", majorVersion: 2)
    ]
)
