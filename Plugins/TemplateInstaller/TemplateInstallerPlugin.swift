import PackagePlugin
import Foundation

@main
struct TemplateInstallerPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let scriptPath = context.package.directory.appending("scripts").appending("install-xctemplates.sh")

        return [
            .prebuildCommand(
                displayName: "Update Async State Templates",
                executable: scriptPath.string,
                arguments: [],
                environment: [:]
            )
        ]
    }
}
