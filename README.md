# CleanUrlsMiddleware
Middleware for Vapor 3 to allow the user to request files without extension from the Public dir

It's a copy-paste of the Middleware provided by Vapor called `FileMiddleware` with an added bonus: Allow users to request files without extensions.

### Usage

Add the following to your `configure.swift`
```swift
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // ...
    // ...
    services.register { container -> CleanUrlsMiddleware in
        let directory = try container.make(DirectoryConfig.self, for: CleanUrlsMiddleware.self)
        return CleanUrlsMiddleware(publicDirectory: directory.workDir + "Public/")
    }

    // ...
    // ...
    // ...
    
    // Register middleware
    // ...
    // ...
    middlewares.use(CleanUrlsMiddleware.self) // Serves files from `Public/` directory
    // ...
    // ...
    services.register(middlewares)

    // Configure the rest of your application here
}
```

### Notes

It will retrieve the first match.
