//
//  Space.swift
//  modules
//
//  Created by Krzysiek on 2025-04-08.
//
import Foundation

// MARK: - Space
public enum Space {
    /// 4 px
    public static let s4: CGFloat = 4
    /// 8 px
    public static let s8: CGFloat = 8
    /// 12 px
    public static let s12: CGFloat = 12
    /// 16 px
    public static let s16: CGFloat = 16
    /// 20 px
    public static let s20: CGFloat = 20
    /// 24 px
    public static let s24: CGFloat = 24
    /// 28 px
    public static let s28: CGFloat = 28
    /// 32 px
    public static let s32: CGFloat = 32
    /// 40 px
    public static let s40: CGFloat = 40
    /// 48 px
    public static let s48: CGFloat = 48
    /// 56 px
    public static let s56: CGFloat = 56
}

// MARK: - Spacing
public enum Spacing {
    public static let zero: CGFloat = 0
    /// 4 px
    public static let xxs = Space.s4
    /// 8 px
    public static let xs = Space.s8
    /// 12 px
    public static let s = Space.s12
    /// 16 px
    public static let m = Space.s16
    /// 24 px
    public static let l = Space.s24
    /// 32 px
    public static let h = Space.s32
}

public typealias Radius = Space
public typealias Size = Space
