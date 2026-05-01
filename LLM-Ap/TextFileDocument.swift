//
//  TextFileDocument.swift
//  LLM-Ap
//
//  Created by Assistant on 26/11/25.
//

import SwiftUI
import UniformTypeIdentifiers

public struct TextFileDocument: FileDocument {
    public static var readableContentTypes: [UTType] { [.plainText] }
    public var text: String

    public init(text: String = "") {
        self.text = text
    }

    public init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents,
           let string = String(data: data, encoding: .utf8) {
            self.text = string
        } else {
            self.text = ""
        }
    }

    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8) ?? Data()
        return .init(regularFileWithContents: data)
    }
}
