import Foundation
import PackagePlugin

/// Executes a command to install the lastest AsyncState templates
/// Requires an xcode restart to take effect
@main public struct InstallTemplatesPlugin: CommandPlugin {
    public init() { }
    public func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        let fileManager = FileManager.default
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        let customTemplateDirectory = homeDirectory.appendingPathComponent("Library/Developer/Xcode/Templates/Async State")
        let sourceTemplatesDirectory = context.package.directory.appending("xctemplates")

        do {
            if fileManager.fileExists(atPath: customTemplateDirectory.path) {
                print("Removing existing templates")
                let existingTemplates = try fileManager.contentsOfDirectory(atPath: customTemplateDirectory.path)
                for template in existingTemplates {
                    let templatePath = customTemplateDirectory.appendingPathComponent(template).path
                    try fileManager.removeItem(atPath: templatePath)
                }
            } else {
                print("Creating directory for custom Xcode templates")
                try fileManager.createDirectory(at: customTemplateDirectory, withIntermediateDirectories: true, attributes: nil)
            }

            print("Copying latest templates")
            let templates = try fileManager.contentsOfDirectory(atPath: sourceTemplatesDirectory.string)
            for template in templates {
                let sourcePath = sourceTemplatesDirectory.appending(template)
                let destinationPath = customTemplateDirectory.appendingPathComponent(template).path
                try fileManager.copyItem(atPath: sourcePath.string, toPath: destinationPath)
                print("Created: \(destinationPath)")
            }
            print("done")
        } catch {
            print("An error occurred: \(error)")
        }
    }
}
