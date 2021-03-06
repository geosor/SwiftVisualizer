//
//  Resolver.swift
//  Yams
//
//  Created by Norio Nomura on 12/15/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

import Foundation

public final class Resolver {
    let tagNamePatternPairs: [(Tag.Name, NSRegularExpression)]
    init(_ tagPatternPairs: [(Tag.Name, String)] = []) {
        self.tagNamePatternPairs = tagPatternPairs.map { ($0, pattern($1)) }
    }

    public func resolveTag(of node: Node) -> Tag.Name {
        switch node {
        case let .scalar(string, tag, _):
            return tag.name == .implicit ? resolveTag(from: string) : tag.name
        case let .mapping(_, tag, _):
            return tag.name == .implicit ? .map : tag.name
        case let .sequence(_, tag, _):
            return tag.name == .implicit ? .seq : tag.name
        }
    }

    private func resolveTag(from string: String) -> Tag.Name {
        for (tag, regexp) in tagNamePatternPairs where regexp.matches(in: string) {
            return tag
        }
        return .str
    }
}

extension Resolver {
    public static let basic = Resolver()
    public static let `default` = Resolver([
        (.bool, [
            "^(?:yes|Yes|YES|no|No|NO",
            "|true|True|TRUE|false|False|FALSE",
            "|on|On|ON|off|Off|OFF)$"
            ].joined()),
        (.int, [
            "^(?:[-+]?0b[0-1_]+",
            "|[-+]?0o?[0-7_]+",
            "|[-+]?(?:0|[1-9][0-9_]*)",
            "|[-+]?0x[0-9a-fA-F_]+",
            "|[-+]?[1-9][0-9_]*(?::[0-5]?[0-9])+)$"
            ].joined()),
        (.float, [
            "^(?:[-+]?(?:[0-9][0-9_]*)(?:\\.[0-9_]*)?(?:[eE][-+]?[0-9]+)?",
            "|\\.[0-9_]+(?:[eE][-+][0-9]+)?",
            "|[-+]?[0-9][0-9_]*(?::[0-5]?[0-9])+\\.[0-9_]*",
            "|[-+]?\\.(?:inf|Inf|INF)",
            "|\\.(?:nan|NaN|NAN))$"
            ].joined()),
        (.merge, "^(?:<<)$"),
        (.null, [
            "^(?:~",
            "|null|Null|NULL",
            "|)$"
            ].joined()),
        (.timestamp, [
            "^(?:[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]",
            "|[0-9][0-9][0-9][0-9]-[0-9][0-9]?-[0-9][0-9]?",
            "(?:[Tt]|[ \\t]+)[0-9][0-9]?",
            ":[0-9][0-9]:[0-9][0-9](?:\\.[0-9]*)?",
            "(?:[ \\t]*(?:Z|[-+][0-9][0-9]?(?::[0-9][0-9])?))?)$"
            ].joined()),
        (.value, "^(?:=)$")
    ])
}

#if os(Linux)
    typealias NSRegularExpression = RegularExpression
#endif

func pattern(_ string: String) -> NSRegularExpression {
    do {
        return try .init(pattern: string, options: [])
    } catch {
        fatalError("unreachable")
    }
}

extension NSRegularExpression {
    fileprivate func matches(in string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        if let match = firstMatch(in: string, options: [], range: range) {
            return match.range.location != NSNotFound
        }
        return false
    }
}
