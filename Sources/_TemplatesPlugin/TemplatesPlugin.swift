//
//  TemplatesPlugin.swift
//  AsyncState
//
//  Created by Peter Schuette on 9/18/24.
//

@freestanding(expression)
macro installAsyncStateTemplates() -> String = #externalMacro(module: "TemplateInstallerPlugin", type: "RunScriptMacro")