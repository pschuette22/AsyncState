import Foundation
import PackagePlugin

/// Executes a command to install the lastest AsyncState templates
/// Requires an xcode restart to take effect
@main public struct TemplateInstallerPlugin: CommandPlugin {
    public init() { }
    public func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        let scriptPath = context.package.directory.appending("scripts").appending("install-xctemplates.sh")
        print(scriptPath.string)
        // TODO: run script
    }
}
