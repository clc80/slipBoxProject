//
//  NSAttributedString+Data+Helper.swift
//  SlipBoxProject
//
//  Created by Claudia Maciel on 5/12/25.
//

import Foundation

extension NSAttributedString {
    func toData() -> Data? {
        let options: [NSAttributedString.DocumentAttributeKey: Any] = [.documentType: NSAttributedString.DocumentType.rtf, .characterEncoding: String.Encoding.utf8]

        let range = NSRange(location: 0, length: length)

        guard let result = try? data(from: range, documentAttributes: options) else {
            return nil
        }
        return result
    }
}

extension Data {
    func toAttributedString() -> NSAttributedString? {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.rtf, .characterEncoding: String.Encoding.utf8]

        let result = try? NSAttributedString(data: self, options: options, documentAttributes: nil)

        return result
    }
}
