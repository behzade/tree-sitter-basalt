import XCTest
import SwiftTreeSitter
import TreeSitterBasalt

final class TreeSitterBasaltTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_basalt())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading Basalt grammar")
    }
}
