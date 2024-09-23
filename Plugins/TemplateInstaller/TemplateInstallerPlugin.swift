import Foundation
import PackagePlugin

@main
public struct TemplateInstallerPlugin: BuildToolPlugin {
  public init() {}

  public func createBuildCommands(context: PluginContext, target _: Target) throws -> [Command] {
    let scriptPath = context.package.directory.appending("scripts").appending("install-xctemplates.sh")

    return [
      .prebuildCommand(
        displayName: "Update Async State Templates",
        executable: scriptPath,
        arguments: [],
        environment: [:],
        outputFilesDirectory: context.package.directory
      ),
    ]
  }
}
