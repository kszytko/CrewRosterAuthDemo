// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen


import SwiftUI
#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.SystemColor", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.SystemColor

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
  public enum Colors {
    public enum ZPallete {
      public static let blue100 = ColorAsset(name: "Blue100")
      public static let blue200 = ColorAsset(name: "Blue200")
      public static let blue300 = ColorAsset(name: "Blue300")
      public static let blue400 = ColorAsset(name: "Blue400")
      public static let blue50 = ColorAsset(name: "Blue50")
      public static let blue500 = ColorAsset(name: "Blue500")
      public static let blue600 = ColorAsset(name: "Blue600")
      public static let blue700 = ColorAsset(name: "Blue700")
      public static let blue800 = ColorAsset(name: "Blue800")
      public static let blue900 = ColorAsset(name: "Blue900")
      public static let blueA100 = ColorAsset(name: "BlueA100")
      public static let blueA200 = ColorAsset(name: "BlueA200")
      public static let blueA400 = ColorAsset(name: "BlueA400")
      public static let blueA700 = ColorAsset(name: "BlueA700")
    }
    public static let background = ColorAsset(name: "background")
  }
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias SystemColor = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias SystemColor = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var systemColor: SystemColor = {
    guard let color = SystemColor(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  public private(set) lazy var color: Color = {
    Color(systemColor)
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.SystemColor {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}

// swiftlint:enable convenience_type

extension ColorAsset: @unchecked Sendable { }
// swiftlint:enable all
