import Foundation
import Vapor

/// Services files from the public folder.
public final class PublicFilesMiddleware: Middleware, Service {
    /// The public directory.
    /// note: does _not_ end with a slash
    let publicDirectory: String

    public var webTypes = [MediaType]()

    /// Creates a new filemiddleware.
    public init(publicDirectory: String) {
        self.publicDirectory = publicDirectory.hasSuffix("/") ? publicDirectory : publicDirectory + "/"
    }

    public func pathForfirstMatchingFile(withName path: String) -> String? {
        var isDirectory: ObjCBool = false
        _ = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        guard !isDirectory.boolValue else {
            return nil
        }
        guard let fileName = path.components(separatedBy: "/").last else {
            return nil
        }

        let pathWithoutFilename = path.components(separatedBy: "/").dropLast().joined(separator: "/")
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: pathWithoutFilename) else {
            return nil
        }

        // TODO Consider files without extensions
        let matchedFiles = files.filter { file -> Bool in
            file.starts(with: fileName)
        }

        guard let firstMatch = matchedFiles.first else {
            return nil
        }

        return pathWithoutFilename + "/" + firstMatch
    }


    /// See Middleware.respond.
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        var filePath = req.http.uri.path
        if filePath.hasPrefix("/") {
            filePath = String(filePath.dropFirst())
        }
        guard !filePath.contains("../") else {
            throw Abort(.forbidden)
        }

        let fullFilePath = self.publicDirectory + filePath

        guard let retrievedPath = pathForfirstMatchingFile(withName: fullFilePath) else {
            return try next.respond(to: req)
        }

        return Future(try req.streamFile(at: retrievedPath))
    }
}
