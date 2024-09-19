//
//  TemplatesPlugin.swift
//  AsyncState
//
//  Created by Peter Schuette on 9/18/24.
//

@freestanding(expression)
public macro installAsyncStateTemplates() -> String = #externalMacro(module: "AsyncStateTemplateInstaller", type: "TemplateInstallerPlugin")
