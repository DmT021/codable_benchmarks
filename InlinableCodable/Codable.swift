//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// Copied from https://github.com/apple/swift/blob/main/stdlib/public/core/Codable.swift
// Modified to allow agressive inlining

//===----------------------------------------------------------------------===//
// Codable
//===----------------------------------------------------------------------===//

/// A type that can encode itself to an external representation.
public protocol Encodable {
  func encode(to encoder: Encoder) throws
}

/// A type that can decode itself from an external representation.
public protocol Decodable {
  init(from decoder: Decoder) throws
}

/// A type that can convert itself into and out of an external representation.
///
/// `Codable` is a type alias for the `Encodable` and `Decodable` protocols.
/// When you use `Codable` as a type or a generic constraint, it matches
/// any type that conforms to both protocols.
public typealias Codable = Encodable & Decodable


//===----------------------------------------------------------------------===//
// Encoder & Decoder
//===----------------------------------------------------------------------===//

/// A type that can encode values into a native format for external
/// representation.
public protocol Encoder {
  var codingPath: [CodingKey] { get }

  var userInfo: [CodingUserInfoKey: Any] { get }

  func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>

  func unkeyedContainer() -> UnkeyedEncodingContainer

  func singleValueContainer() -> SingleValueEncodingContainer
}

/// A type that can decode values from a native format into in-memory
/// representations.
public protocol Decoder {
  var codingPath: [CodingKey] { get }

  var userInfo: [CodingUserInfoKey: Any] { get }

  func container<Key>(
    keyedBy type: Key.Type
  ) throws -> KeyedDecodingContainer<Key>

  func unkeyedContainer() throws -> UnkeyedDecodingContainer

  func singleValueContainer() throws -> SingleValueDecodingContainer
}

//===----------------------------------------------------------------------===//
// Keyed Encoding Containers
//===----------------------------------------------------------------------===//

/// A type that provides a view into an encoder's storage and is used to hold
/// the encoded properties of an encodable type in a keyed manner.
///
/// Encoders should provide types conforming to
/// `KeyedEncodingContainerProtocol` for their format.
public protocol KeyedEncodingContainerProtocol {
  associatedtype Key: CodingKey

  var codingPath: [CodingKey] { get }

  mutating func encodeNil(forKey key: Key) throws

  mutating func encode(_ value: Bool, forKey key: Key) throws

  mutating func encode(_ value: String, forKey key: Key) throws

  mutating func encode(_ value: Double, forKey key: Key) throws

  mutating func encode(_ value: Float, forKey key: Key) throws

  mutating func encode(_ value: Int, forKey key: Key) throws

  mutating func encode(_ value: Int8, forKey key: Key) throws

  mutating func encode(_ value: Int16, forKey key: Key) throws

  mutating func encode(_ value: Int32, forKey key: Key) throws

  mutating func encode(_ value: Int64, forKey key: Key) throws

  mutating func encode(_ value: UInt, forKey key: Key) throws

  mutating func encode(_ value: UInt8, forKey key: Key) throws

  mutating func encode(_ value: UInt16, forKey key: Key) throws

  mutating func encode(_ value: UInt32, forKey key: Key) throws

  mutating func encode(_ value: UInt64, forKey key: Key) throws

  mutating func encode<T: Encodable>(_ value: T, forKey key: Key) throws

  mutating func encodeConditional<T: AnyObject & Encodable>(
    _ object: T,
    forKey key: Key
  ) throws

  mutating func encodeIfPresent(_ value: Bool?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: String?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: Double?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: Float?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: Int?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: Int8?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: Int16?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: Int32?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: Int64?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: UInt?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: UInt8?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: UInt16?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: UInt32?, forKey key: Key) throws

  mutating func encodeIfPresent(_ value: UInt64?, forKey key: Key) throws

  mutating func encodeIfPresent<T: Encodable>(
    _ value: T?,
    forKey key: Key
  ) throws

  mutating func nestedContainer<NestedKey>(
    keyedBy keyType: NestedKey.Type,
    forKey key: Key
  ) -> KeyedEncodingContainer<NestedKey>

  mutating func nestedUnkeyedContainer(
    forKey key: Key
  ) -> UnkeyedEncodingContainer

  mutating func superEncoder() -> Encoder

  mutating func superEncoder(forKey key: Key) -> Encoder
}

// An implementation of _KeyedEncodingContainerBase and
// _KeyedEncodingContainerBox are given at the bottom of this file.

/// A concrete container that provides a view into an encoder's storage, making
/// the encoded properties of an encodable type accessible by keys.
public struct KeyedEncodingContainer<K: CodingKey> :
  KeyedEncodingContainerProtocol
{
  public typealias Key = K

  @usableFromInline
  internal let _box: _KeyedEncodingContainerBase

  @inlinable public init<Container: KeyedEncodingContainerProtocol>(
    _ container: Container
  ) where Container.Key == Key {
    _box = _KeyedEncodingContainerBox(container)
  }

  @inlinable public var codingPath: [CodingKey] {
    return _box.codingPath
  }

  @inlinable public mutating func encodeNil(forKey key: Key) throws {
    try _box.encodeNil(forKey: key)
  }

  @inlinable public mutating func encode(_ value: Bool, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: String, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: Double, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: Float, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: Int, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: Int8, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: Int16, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: Int32, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: Int64, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: UInt, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: UInt8, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: UInt16, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: UInt32, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode(_ value: UInt64, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encode<T: Encodable>(
    _ value: T,
    forKey key: Key
  ) throws {
    try _box.encode(value, forKey: key)
  }

  @inlinable public mutating func encodeConditional<T: AnyObject & Encodable>(
    _ object: T,
    forKey key: Key
  ) throws {
    try _box.encodeConditional(object, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Bool?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: String?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Double?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Float?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Int?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Int8?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Int16?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Int32?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Int64?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: UInt?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: UInt8?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: UInt16?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: UInt32?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: UInt64?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent<T: Encodable>(
    _ value: T?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }

  @inlinable public mutating func nestedContainer<NestedKey>(
    keyedBy keyType: NestedKey.Type,
    forKey key: Key
  ) -> KeyedEncodingContainer<NestedKey> {
    return _box.nestedContainer(keyedBy: NestedKey.self, forKey: key)
  }

  @inlinable public mutating func nestedUnkeyedContainer(
    forKey key: Key
  ) -> UnkeyedEncodingContainer {
    return _box.nestedUnkeyedContainer(forKey: key)
  }

  @inlinable public mutating func superEncoder() -> Encoder {
    return _box.superEncoder()
  }

  @inlinable public mutating func superEncoder(forKey key: Key) -> Encoder {
    return _box.superEncoder(forKey: key)
  }
}

/// A type that provides a view into a decoder's storage and is used to hold
/// the encoded properties of a decodable type in a keyed manner.
///
/// Decoders should provide types conforming to `UnkeyedDecodingContainer` for
/// their format.
public protocol KeyedDecodingContainerProtocol {
  associatedtype Key: CodingKey

  var codingPath: [CodingKey] { get }

  var allKeys: [Key] { get }

  func contains(_ key: Key) -> Bool

  func decodeNil(forKey key: Key) throws -> Bool

  func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool

  func decode(_ type: String.Type, forKey key: Key) throws -> String

  func decode(_ type: Double.Type, forKey key: Key) throws -> Double

  func decode(_ type: Float.Type, forKey key: Key) throws -> Float

  func decode(_ type: Int.Type, forKey key: Key) throws -> Int

  func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8

  func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16

  func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32

  func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64

  func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt

  func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8

  func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16

  func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32

  func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64

  func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T

  func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool?

  func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String?

  func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double?

  func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float?

  func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int?

  func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws -> Int8?

  func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws -> Int16?

  func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws -> Int32?

  func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws -> Int64?

  func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws -> UInt?

  func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws -> UInt8?

  func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16?

  func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32?

  func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64?

  func decodeIfPresent<T: Decodable>(
    _ type: T.Type,
    forKey key: Key
  ) throws -> T?

  func nestedContainer<NestedKey>(
    keyedBy type: NestedKey.Type,
    forKey key: Key
  ) throws -> KeyedDecodingContainer<NestedKey>

  func nestedUnkeyedContainer(
    forKey key: Key
  ) throws -> UnkeyedDecodingContainer

  func superDecoder() throws -> Decoder

  func superDecoder(forKey key: Key) throws -> Decoder
}

// An implementation of _KeyedDecodingContainerBase and
// _KeyedDecodingContainerBox are given at the bottom of this file.

/// A concrete container that provides a view into a decoder's storage, making
/// the encoded properties of a decodable type accessible by keys.
public struct KeyedDecodingContainer<K: CodingKey> :
  KeyedDecodingContainerProtocol
{
  public typealias Key = K

  @usableFromInline
  internal var _box: _KeyedDecodingContainerBase

  @inlinable public init<Container: KeyedDecodingContainerProtocol>(
    _ container: Container
  ) where Container.Key == Key {
    _box = _KeyedDecodingContainerBox(container)
  }

  @inlinable public var codingPath: [CodingKey] {
    return _box.codingPath
  }

  @inlinable public var allKeys: [Key] {
    return _box.allKeys as! [Key]
  }

  @inlinable public func contains(_ key: Key) -> Bool {
    return _box.contains(key)
  }

  @inlinable public func decodeNil(forKey key: Key) throws -> Bool {
    return try _box.decodeNil(forKey: key)
  }

  @inlinable public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
    return try _box.decode(Bool.self, forKey: key)
  }

  @inlinable public func decode(_ type: String.Type, forKey key: Key) throws -> String {
    return try _box.decode(String.self, forKey: key)
  }

  @inlinable public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
    return try _box.decode(Double.self, forKey: key)
  }

  @inlinable public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
    return try _box.decode(Float.self, forKey: key)
  }

  @inlinable public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
    return try _box.decode(Int.self, forKey: key)
  }

  @inlinable public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
    return try _box.decode(Int8.self, forKey: key)
  }

  @inlinable public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
    return try _box.decode(Int16.self, forKey: key)
  }

  @inlinable public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
    return try _box.decode(Int32.self, forKey: key)
  }

  @inlinable public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
    return try _box.decode(Int64.self, forKey: key)
  }

  @inlinable public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
    return try _box.decode(UInt.self, forKey: key)
  }

  @inlinable public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
    return try _box.decode(UInt8.self, forKey: key)
  }

  @inlinable public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
    return try _box.decode(UInt16.self, forKey: key)
  }

  @inlinable public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
    return try _box.decode(UInt32.self, forKey: key)
  }

  @inlinable public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
    return try _box.decode(UInt64.self, forKey: key)
  }

  @inlinable public func decode<T: Decodable>(
    _ type: T.Type,
    forKey key: Key
  ) throws -> T {
    return try _box.decode(T.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Bool.Type,
    forKey key: Key
  ) throws -> Bool? {
    return try _box.decodeIfPresent(Bool.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: String.Type,
    forKey key: Key
  ) throws -> String? {
    return try _box.decodeIfPresent(String.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Double.Type,
    forKey key: Key
  ) throws -> Double? {
    return try _box.decodeIfPresent(Double.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Float.Type,
    forKey key: Key
  ) throws -> Float? {
    return try _box.decodeIfPresent(Float.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Int.Type,
    forKey key: Key
  ) throws -> Int? {
    return try _box.decodeIfPresent(Int.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Int8.Type,
    forKey key: Key
  ) throws -> Int8? {
    return try _box.decodeIfPresent(Int8.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Int16.Type,
    forKey key: Key
  ) throws -> Int16? {
    return try _box.decodeIfPresent(Int16.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Int32.Type,
    forKey key: Key
  ) throws -> Int32? {
    return try _box.decodeIfPresent(Int32.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Int64.Type,
    forKey key: Key
  ) throws -> Int64? {
    return try _box.decodeIfPresent(Int64.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: UInt.Type,
    forKey key: Key
  ) throws -> UInt? {
    return try _box.decodeIfPresent(UInt.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: UInt8.Type,
    forKey key: Key
  ) throws -> UInt8? {
    return try _box.decodeIfPresent(UInt8.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: UInt16.Type,
    forKey key: Key
  ) throws -> UInt16? {
    return try _box.decodeIfPresent(UInt16.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: UInt32.Type,
    forKey key: Key
  ) throws -> UInt32? {
    return try _box.decodeIfPresent(UInt32.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: UInt64.Type,
    forKey key: Key
  ) throws -> UInt64? {
    return try _box.decodeIfPresent(UInt64.self, forKey: key)
  }

  @inlinable public func decodeIfPresent<T: Decodable>(
    _ type: T.Type,
    forKey key: Key
  ) throws -> T? {
    return try _box.decodeIfPresent(T.self, forKey: key)
  }

  @inlinable public func nestedContainer<NestedKey>(
    keyedBy type: NestedKey.Type,
    forKey key: Key
  ) throws -> KeyedDecodingContainer<NestedKey> {
    return try _box.nestedContainer(keyedBy: NestedKey.self, forKey: key)
  }

  @inlinable public func nestedUnkeyedContainer(
    forKey key: Key
  ) throws -> UnkeyedDecodingContainer {
    return try _box.nestedUnkeyedContainer(forKey: key)
  }

  @inlinable public func superDecoder() throws -> Decoder {
    return try _box.superDecoder()
  }

  @inlinable public func superDecoder(forKey key: Key) throws -> Decoder {
    return try _box.superDecoder(forKey: key)
  }
}

//===----------------------------------------------------------------------===//
// Unkeyed Encoding Containers
//===----------------------------------------------------------------------===//

/// A type that provides a view into an encoder's storage and is used to hold
/// the encoded properties of an encodable type sequentially, without keys.
///
/// Encoders should provide types conforming to `UnkeyedEncodingContainer` for
/// their format.
public protocol UnkeyedEncodingContainer {
  var codingPath: [CodingKey] { get }

  var count: Int { get }

  mutating func encodeNil() throws

  mutating func encode(_ value: Bool) throws

  mutating func encode(_ value: String) throws

  mutating func encode(_ value: Double) throws

  mutating func encode(_ value: Float) throws

  mutating func encode(_ value: Int) throws

  mutating func encode(_ value: Int8) throws

  mutating func encode(_ value: Int16) throws

  mutating func encode(_ value: Int32) throws

  mutating func encode(_ value: Int64) throws

  mutating func encode(_ value: UInt) throws

  mutating func encode(_ value: UInt8) throws

  mutating func encode(_ value: UInt16) throws

  mutating func encode(_ value: UInt32) throws

  mutating func encode(_ value: UInt64) throws

  mutating func encode<T: Encodable>(_ value: T) throws

  mutating func encodeConditional<T: AnyObject & Encodable>(_ object: T) throws

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Bool

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == String

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Double

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Float

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int8

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int16

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int32

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int64

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt8

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt16

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt32

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt64

  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element: Encodable

  mutating func nestedContainer<NestedKey>(
    keyedBy keyType: NestedKey.Type
  ) -> KeyedEncodingContainer<NestedKey>

  mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer

  mutating func superEncoder() -> Encoder
}

/// A type that provides a view into a decoder's storage and is used to hold
/// the encoded properties of a decodable type sequentially, without keys.
///
/// Decoders should provide types conforming to `UnkeyedDecodingContainer` for
/// their format.
public protocol UnkeyedDecodingContainer {
  var codingPath: [CodingKey] { get }

  var count: Int? { get }

  var isAtEnd: Bool { get }

  var currentIndex: Int { get }

  mutating func decodeNil() throws -> Bool

  mutating func decode(_ type: Bool.Type) throws -> Bool

  mutating func decode(_ type: String.Type) throws -> String

  mutating func decode(_ type: Double.Type) throws -> Double

  mutating func decode(_ type: Float.Type) throws -> Float

  mutating func decode(_ type: Int.Type) throws -> Int

  mutating func decode(_ type: Int8.Type) throws -> Int8

  mutating func decode(_ type: Int16.Type) throws -> Int16

  mutating func decode(_ type: Int32.Type) throws -> Int32

  mutating func decode(_ type: Int64.Type) throws -> Int64

  mutating func decode(_ type: UInt.Type) throws -> UInt

  mutating func decode(_ type: UInt8.Type) throws -> UInt8

  mutating func decode(_ type: UInt16.Type) throws -> UInt16

  mutating func decode(_ type: UInt32.Type) throws -> UInt32

  mutating func decode(_ type: UInt64.Type) throws -> UInt64

  mutating func decode<T: Decodable>(_ type: T.Type) throws -> T

  mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool?

  mutating func decodeIfPresent(_ type: String.Type) throws -> String?

  mutating func decodeIfPresent(_ type: Double.Type) throws -> Double?

  mutating func decodeIfPresent(_ type: Float.Type) throws -> Float?

  mutating func decodeIfPresent(_ type: Int.Type) throws -> Int?

  mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8?

  mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16?

  mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32?

  mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64?

  mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt?

  mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8?

  mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16?

  mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32?

  mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64?

  mutating func decodeIfPresent<T: Decodable>(_ type: T.Type) throws -> T?

  mutating func nestedContainer<NestedKey>(
    keyedBy type: NestedKey.Type
  ) throws -> KeyedDecodingContainer<NestedKey>

  mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer

  mutating func superDecoder() throws -> Decoder
}

//===----------------------------------------------------------------------===//
// Single Value Encoding Containers
//===----------------------------------------------------------------------===//

/// A container that can support the storage and direct encoding of a single
/// non-keyed value.
public protocol SingleValueEncodingContainer {
  var codingPath: [CodingKey] { get }

  mutating func encodeNil() throws

  mutating func encode(_ value: Bool) throws

  mutating func encode(_ value: String) throws

  mutating func encode(_ value: Double) throws

  mutating func encode(_ value: Float) throws

  mutating func encode(_ value: Int) throws

  mutating func encode(_ value: Int8) throws

  mutating func encode(_ value: Int16) throws

  mutating func encode(_ value: Int32) throws

  mutating func encode(_ value: Int64) throws

  mutating func encode(_ value: UInt) throws

  mutating func encode(_ value: UInt8) throws

  mutating func encode(_ value: UInt16) throws

  mutating func encode(_ value: UInt32) throws

  mutating func encode(_ value: UInt64) throws

  mutating func encode<T: Encodable>(_ value: T) throws
}

/// A container that can support the storage and direct decoding of a single
/// nonkeyed value.
public protocol SingleValueDecodingContainer {
  var codingPath: [CodingKey] { get }

  func decodeNil() -> Bool

  func decode(_ type: Bool.Type) throws -> Bool

  func decode(_ type: String.Type) throws -> String

  func decode(_ type: Double.Type) throws -> Double

  func decode(_ type: Float.Type) throws -> Float

  func decode(_ type: Int.Type) throws -> Int

  func decode(_ type: Int8.Type) throws -> Int8

  func decode(_ type: Int16.Type) throws -> Int16

  func decode(_ type: Int32.Type) throws -> Int32

  func decode(_ type: Int64.Type) throws -> Int64

  func decode(_ type: UInt.Type) throws -> UInt

  func decode(_ type: UInt8.Type) throws -> UInt8

  func decode(_ type: UInt16.Type) throws -> UInt16

  func decode(_ type: UInt32.Type) throws -> UInt32

  func decode(_ type: UInt64.Type) throws -> UInt64

  func decode<T: Decodable>(_ type: T.Type) throws -> T
}

//===----------------------------------------------------------------------===//
// Errors
//===----------------------------------------------------------------------===//

// The following extensions allow for easier error construction.

@usableFromInline
internal struct _GenericIndexKey: CodingKey, Sendable {
  @usableFromInline
  internal var stringValue: String
  @usableFromInline
  internal var intValue: Int?

  @inlinable
  internal init?(stringValue: String) {
    return nil
  }

  @inlinable
  internal init?(intValue: Int) {
    self.stringValue = "Index \(intValue)"
    self.intValue = intValue
  }
}

extension DecodingError {
  @inlinable public static func dataCorruptedError<C: KeyedDecodingContainerProtocol>(
    forKey key: C.Key,
    in container: C,
    debugDescription: String
  ) -> DecodingError {
    let context = DecodingError.Context(
      codingPath: container.codingPath + [key],
      debugDescription: debugDescription)
    return .dataCorrupted(context)
  }

  @inlinable public static func dataCorruptedError(
    in container: UnkeyedDecodingContainer,
    debugDescription: String
  ) -> DecodingError {
    let context = DecodingError.Context(
      codingPath: container.codingPath +
        [_GenericIndexKey(intValue: container.currentIndex)!],
      debugDescription: debugDescription)
    return .dataCorrupted(context)
  }

  @inlinable public static func dataCorruptedError(
    in container: SingleValueDecodingContainer,
    debugDescription: String
  ) -> DecodingError {
    let context = DecodingError.Context(codingPath: container.codingPath,
      debugDescription: debugDescription)
    return .dataCorrupted(context)
  }
}


//===----------------------------------------------------------------------===//
// Keyed Encoding Container Implementations
//===----------------------------------------------------------------------===//

@usableFromInline
internal class _KeyedEncodingContainerBase {
  @inlinable internal init(){}

  @inlinable deinit {}

  // These must all be given a concrete implementation in _*Box.
  @inlinable internal var codingPath: [CodingKey] {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeNil<K: CodingKey>(forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: Bool, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: String, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: Double, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: Float, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: Int, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: Int8, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: Int16, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: Int32, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: Int64, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: UInt, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: UInt8, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: UInt16, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: UInt32, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<K: CodingKey>(_ value: UInt64, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encode<T: Encodable, K: CodingKey>(_ value: T, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeConditional<T: AnyObject & Encodable, K: CodingKey>(
    _ object: T,
    forKey key: K
  ) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: Bool?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: String?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: Double?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: Float?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: Int?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: Int8?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: Int16?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: Int32?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: Int64?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: UInt?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: UInt8?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: UInt16?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: UInt32?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<K: CodingKey>(_ value: UInt64?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func encodeIfPresent<T: Encodable, K: CodingKey>(
    _ value: T?,
    forKey key: K
  ) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func nestedContainer<NestedKey, K: CodingKey>(
    keyedBy keyType: NestedKey.Type,
    forKey key: K
  ) -> KeyedEncodingContainer<NestedKey> {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func nestedUnkeyedContainer<K: CodingKey>(
    forKey key: K
  ) -> UnkeyedEncodingContainer {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func superEncoder() -> Encoder {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  @inlinable internal func superEncoder<K: CodingKey>(forKey key: K) -> Encoder {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
}

@usableFromInline
internal final class _KeyedEncodingContainerBox<
  Concrete: KeyedEncodingContainerProtocol
>: _KeyedEncodingContainerBase {
  @usableFromInline
  typealias Key = Concrete.Key

  @usableFromInline
  internal let c: Concrete

  @inlinable
  internal var concrete: Concrete {
    get { c }
    set {}
  }

  @inlinable internal init(_ container: Concrete) {
    c = container
  }

  @inlinable deinit {}

  override internal var codingPath: [CodingKey] {
    return concrete.codingPath
  }

  override internal func encodeNil<K: CodingKey>(forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeNil(forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Bool, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  @inlinable override internal func encode<K: CodingKey>(_ value: String, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Double, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Float, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  @inlinable override internal func encode<K: CodingKey>(_ value: Int, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Int8, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Int16, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Int32, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Int64, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: UInt, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: UInt8, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: UInt16, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: UInt32, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: UInt64, forKey key: K) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  @inlinable override internal func encode<T: Encodable, K: CodingKey>(
    _ value: T,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encodeConditional<T: AnyObject & Encodable, K: CodingKey>(
    _ object: T,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeConditional(object, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Bool?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: String?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Double?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Float?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int8?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int16?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int32?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int64?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt8?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt16?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt32?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt64?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<T: Encodable, K: CodingKey>(
    _ value: T?,
    forKey key: K
  ) throws {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func nestedContainer<NestedKey, K: CodingKey>(
    keyedBy keyType: NestedKey.Type,
    forKey key: K
  ) -> KeyedEncodingContainer<NestedKey> {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return concrete.nestedContainer(keyedBy: NestedKey.self, forKey: key)
  }

  override internal func nestedUnkeyedContainer<K: CodingKey>(
    forKey key: K
  ) -> UnkeyedEncodingContainer {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return concrete.nestedUnkeyedContainer(forKey: key)
  }

  override internal func superEncoder() -> Encoder {
    return concrete.superEncoder()
  }

  override internal func superEncoder<K: CodingKey>(forKey key: K) -> Encoder {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return concrete.superEncoder(forKey: key)
  }
}

@usableFromInline
internal class _KeyedDecodingContainerBase {
  @inlinable internal init(){}

  @inlinable deinit {}

  @inlinable internal var codingPath: [CodingKey] {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal var allKeys: [CodingKey] {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func contains<K: CodingKey>(_ key: K) -> Bool {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeNil<K: CodingKey>(forKey key: K) throws -> Bool {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: Bool.Type,
    forKey key: K
  ) throws -> Bool {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: String.Type,
    forKey key: K
  ) throws -> String {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: Double.Type,
    forKey key: K
  ) throws -> Double {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: Float.Type,
    forKey key: K
  ) throws -> Float {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: Int.Type,
    forKey key: K
  ) throws -> Int {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: Int8.Type,
    forKey key: K
  ) throws -> Int8 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: Int16.Type,
    forKey key: K
  ) throws -> Int16 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: Int32.Type,
    forKey key: K
  ) throws -> Int32 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: Int64.Type,
    forKey key: K
  ) throws -> Int64 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: UInt.Type,
    forKey key: K
  ) throws -> UInt {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: UInt8.Type,
    forKey key: K
  ) throws -> UInt8 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: UInt16.Type,
    forKey key: K
  ) throws -> UInt16 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: UInt32.Type,
    forKey key: K
  ) throws -> UInt32 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<K: CodingKey>(
    _ type: UInt64.Type,
    forKey key: K
  ) throws -> UInt64 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decode<T: Decodable, K: CodingKey>(
    _ type: T.Type,
    forKey key: K
  ) throws -> T {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: Bool.Type,
    forKey key: K
  ) throws -> Bool? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: String.Type,
    forKey key: K
  ) throws -> String? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: Double.Type,
    forKey key: K
  ) throws -> Double? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: Float.Type,
    forKey key: K
  ) throws -> Float? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: Int.Type,
    forKey key: K
  ) throws -> Int? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: Int8.Type,
    forKey key: K
  ) throws -> Int8? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: Int16.Type,
    forKey key: K
  ) throws -> Int16? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: Int32.Type,
    forKey key: K
  ) throws -> Int32? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: Int64.Type,
    forKey key: K
  ) throws -> Int64? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt.Type,
    forKey key: K
  ) throws -> UInt? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt8.Type,
    forKey key: K
  ) throws -> UInt8? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt16.Type,
    forKey key: K
  ) throws -> UInt16? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt32.Type,
    forKey key: K
  ) throws -> UInt32? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt64.Type,
    forKey key: K
  ) throws -> UInt64? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func decodeIfPresent<T: Decodable, K: CodingKey>(
    _ type: T.Type,
    forKey key: K
  ) throws -> T? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func nestedContainer<NestedKey, K: CodingKey>(
    keyedBy type: NestedKey.Type,
    forKey key: K
  ) throws -> KeyedDecodingContainer<NestedKey> {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func nestedUnkeyedContainer<K: CodingKey>(
    forKey key: K
  ) throws -> UnkeyedDecodingContainer {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func superDecoder() throws -> Decoder {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }

  @inlinable internal func superDecoder<K: CodingKey>(forKey key: K) throws -> Decoder {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
}

@usableFromInline
internal final class _KeyedDecodingContainerBox<
  Concrete: KeyedDecodingContainerProtocol
>: _KeyedDecodingContainerBase {
  @usableFromInline
  typealias Key = Concrete.Key

  @usableFromInline
  internal let concrete: Concrete

  @inlinable internal init(_ container: Concrete) {
    concrete = container
  }

  @inlinable deinit {}

  @inlinable override var codingPath: [CodingKey] {
    return concrete.codingPath
  }

  @inlinable override var allKeys: [CodingKey] {
    return concrete.allKeys
  }

  @inlinable override internal func contains<K: CodingKey>(_ key: K) -> Bool {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return concrete.contains(key)
  }

  @inlinable override internal func decodeNil<K: CodingKey>(forKey key: K) throws -> Bool {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeNil(forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: Bool.Type,
    forKey key: K
  ) throws -> Bool {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Bool.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: String.Type,
    forKey key: K
  ) throws -> String {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(String.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: Double.Type,
    forKey key: K
  ) throws -> Double {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Double.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: Float.Type,
    forKey key: K
  ) throws -> Float {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Float.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: Int.Type,
    forKey key: K
  ) throws -> Int {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Int.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: Int8.Type,
    forKey key: K
  ) throws -> Int8 {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Int8.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: Int16.Type,
    forKey key: K
  ) throws -> Int16 {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Int16.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: Int32.Type,
    forKey key: K
  ) throws -> Int32 {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Int32.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: Int64.Type,
    forKey key: K
  ) throws -> Int64 {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Int64.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: UInt.Type,
    forKey key: K
  ) throws -> UInt {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(UInt.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: UInt8.Type,
    forKey key: K
  ) throws -> UInt8 {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(UInt8.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: UInt16.Type,
    forKey key: K
  ) throws -> UInt16 {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(UInt16.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: UInt32.Type,
    forKey key: K
  ) throws -> UInt32 {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(UInt32.self, forKey: key)
  }

  @inlinable override internal func decode<K: CodingKey>(
    _ type: UInt64.Type,
    forKey key: K
  ) throws -> UInt64 {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(UInt64.self, forKey: key)
  }

  @inlinable override internal func decode<T: Decodable, K: CodingKey>(
    _ type: T.Type,
    forKey key: K
  ) throws -> T {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(T.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: Bool.Type,
    forKey key: K
  ) throws -> Bool? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Bool.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: String.Type,
    forKey key: K
  ) throws -> String? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(String.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: Double.Type,
    forKey key: K
  ) throws -> Double? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Double.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: Float.Type,
    forKey key: K
  ) throws -> Float? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Float.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: Int.Type,
    forKey key: K
  ) throws -> Int? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Int.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: Int8.Type,
    forKey key: K
  ) throws -> Int8? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Int8.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: Int16.Type,
    forKey key: K
  ) throws -> Int16? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Int16.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: Int32.Type,
    forKey key: K
  ) throws -> Int32? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Int32.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: Int64.Type,
    forKey key: K
  ) throws -> Int64? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Int64.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt.Type,
    forKey key: K
  ) throws -> UInt? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(UInt.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt8.Type,
    forKey key: K
  ) throws -> UInt8? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(UInt8.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt16.Type,
    forKey key: K
  ) throws -> UInt16? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(UInt16.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt32.Type,
    forKey key: K
  ) throws -> UInt32? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(UInt32.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt64.Type,
    forKey key: K
  ) throws -> UInt64? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(UInt64.self, forKey: key)
  }

  @inlinable override internal func decodeIfPresent<T: Decodable, K: CodingKey>(
    _ type: T.Type,
    forKey key: K
  ) throws -> T? {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(T.self, forKey: key)
  }

  @inlinable override internal func nestedContainer<NestedKey, K: CodingKey>(
    keyedBy type: NestedKey.Type,
    forKey key: K
  ) throws -> KeyedDecodingContainer<NestedKey> {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.nestedContainer(keyedBy: NestedKey.self, forKey: key)
  }

  @inlinable override internal func nestedUnkeyedContainer<K: CodingKey>(
    forKey key: K
  ) throws -> UnkeyedDecodingContainer {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.nestedUnkeyedContainer(forKey: key)
  }

  @inlinable override internal func superDecoder() throws -> Decoder {
    return try concrete.superDecoder()
  }

  @inlinable override internal func superDecoder<K: CodingKey>(forKey key: K) throws -> Decoder {
    // precondition(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.superDecoder(forKey: key)
  }
}

//===----------------------------------------------------------------------===//
// Primitive and RawRepresentable Extensions
//===----------------------------------------------------------------------===//

extension Bool: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(Bool.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == Bool, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == Bool, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension String: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(String.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == String, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == String, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension Double: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(Double.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == Double, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == Double, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension Float: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(Float.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == Float, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == Float, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension Int: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(Int.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == Int, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == Int, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension Int8: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(Int8.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == Int8, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == Int8, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension Int16: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(Int16.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == Int16, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == Int16, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension Int32: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(Int32.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == Int32, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == Int32, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension Int64: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(Int64.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == Int64, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == Int64, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension UInt: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(UInt.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == UInt, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == UInt, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension UInt8: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(UInt8.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == UInt8, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == UInt8, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension UInt16: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(UInt16.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == UInt16, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == UInt16, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension UInt32: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(UInt32.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == UInt32, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == UInt32, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

extension UInt64: Codable {
  @inlinable public init(from decoder: Decoder) throws {
    self = try decoder.singleValueContainer().decode(UInt64.self)
  }

  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}

extension RawRepresentable where RawValue == UInt64, Self: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension RawRepresentable where RawValue == UInt64, Self: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }

    self = value
  }
}

//===----------------------------------------------------------------------===//
// Optional/Collection Type Conformances
//===----------------------------------------------------------------------===//

extension Optional: Encodable where Wrapped: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .none: try container.encodeNil()
    case .some(let wrapped): try container.encode(wrapped)
    }
  }
}

extension Optional: Decodable where Wrapped: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if container.decodeNil() {
      self = .none
    }  else {
      let element = try container.decode(Wrapped.self)
      self = .some(element)
    }
  }
}

extension Array: Encodable where Element: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    for element in self {
      try container.encode(element)
    }
  }
}

extension Array: Decodable where Element: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    self.init()

    var container = try decoder.unkeyedContainer()
    while !container.isAtEnd {
      let element = try container.decode(Element.self)
      self.append(element)
    }
  }
}

extension ContiguousArray: Encodable where Element: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    for element in self {
      try container.encode(element)
    }
  }
}

extension ContiguousArray: Decodable where Element: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    self.init()

    var container = try decoder.unkeyedContainer()
    while !container.isAtEnd {
      let element = try container.decode(Element.self)
      self.append(element)
    }
  }
}

extension Set: Encodable where Element: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    for element in self {
      try container.encode(element)
    }
  }
}

extension Set: Decodable where Element: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    self.init()

    var container = try decoder.unkeyedContainer()
    while !container.isAtEnd {
      let element = try container.decode(Element.self)
      self.insert(element)
    }
  }
}

/// A wrapper for dictionary keys which are Strings or Ints.
@usableFromInline
internal struct _DictionaryCodingKey: CodingKey {
  @usableFromInline
  internal let stringValue: String
  @usableFromInline
  internal let intValue: Int?

  @inlinable internal init(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = Int(stringValue)
  }

  @inlinable internal init(intValue: Int) {
    self.stringValue = "\(intValue)"
    self.intValue = intValue
  }

  @usableFromInline  init(codingKey: CodingKey) {
    self.stringValue = codingKey.stringValue
    self.intValue = codingKey.intValue
  }
}

extension Dictionary: Encodable where Key: Encodable, Value: Encodable {
  @inlinable public func encode(to encoder: Encoder) throws {
    if Key.self == String.self {
      // Since the keys are already Strings, we can use them as keys directly.
      var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
      for (key, value) in self {
        let codingKey = _DictionaryCodingKey(stringValue: key as! String)
        try container.encode(value, forKey: codingKey)
      }
    } else if Key.self == Int.self {
      // Since the keys are already Ints, we can use them as keys directly.
      var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
      for (key, value) in self {
        let codingKey = _DictionaryCodingKey(intValue: key as! Int)
        try container.encode(value, forKey: codingKey)
      }
    } else if #available(SwiftStdlib 5.6, *),
              Key.self is CodingKeyRepresentable.Type {
      // Since the keys are CodingKeyRepresentable, we can use the `codingKey`
      // to create `_DictionaryCodingKey` instances.
      var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
      for (key, value) in self {
        let codingKey = (key as! CodingKeyRepresentable).codingKey
        let dictionaryCodingKey = _DictionaryCodingKey(codingKey: codingKey)
        try container.encode(value, forKey: dictionaryCodingKey)
      }
    } else {
      // Keys are Encodable but not Strings or Ints, so we cannot arbitrarily
      // convert to keys. We can encode as an array of alternating key-value
      // pairs, though.
      var container = encoder.unkeyedContainer()
      for (key, value) in self {
        try container.encode(key)
        try container.encode(value)
      }
    }
  }
}

extension Dictionary: Decodable where Key: Decodable, Value: Decodable {
  @inlinable public init(from decoder: Decoder) throws {
    self.init()

    if Key.self == String.self {
      // The keys are Strings, so we should be able to expect a keyed container.
      let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
      for key in container.allKeys {
        let value = try container.decode(Value.self, forKey: key)
        self[key.stringValue as! Key] = value
      }
    } else if Key.self == Int.self {
      // The keys are Ints, so we should be able to expect a keyed container.
      let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
      for key in container.allKeys {
        guard key.intValue != nil else {
          // We provide stringValues for Int keys; if an encoder chooses not to
          // use the actual intValues, we've encoded string keys.
          // So on init, _DictionaryCodingKey tries to parse string keys as
          // Ints. If that succeeds, then we would have had an intValue here.
          // We don't, so this isn't a valid Int key.
          var codingPath = decoder.codingPath
          codingPath.append(key)
          throw DecodingError.typeMismatch(
            Int.self,
            DecodingError.Context(
              codingPath: codingPath,
              debugDescription: "Expected Int key but found String key instead."
            )
          )
        }

        let value = try container.decode(Value.self, forKey: key)
        self[key.intValue! as! Key] = value
      }
    } else if #available(SwiftStdlib 5.6, *),
              let keyType = Key.self as? CodingKeyRepresentable.Type {
      // The keys are CodingKeyRepresentable, so we should be able to expect
      // a keyed container.
      let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
      for codingKey in container.allKeys {
        guard let key: Key = keyType.init(codingKey: codingKey) as? Key else {
          throw DecodingError.dataCorruptedError(
            forKey: codingKey,
            in: container,
            debugDescription: "Could not convert key to type \(Key.self)"
          )
        }
        let value: Value = try container.decode(Value.self, forKey: codingKey)
        self[key] = value
      }
    } else {
      // We should have encoded as an array of alternating key-value pairs.
      var container = try decoder.unkeyedContainer()

      // We're expecting to get pairs. If the container has a known count, it
      // had better be even; no point in doing work if not.
      if let count = container.count {
        guard count % 2 == 0 else {
          throw DecodingError.dataCorrupted(
            DecodingError.Context(
              codingPath: decoder.codingPath,
              debugDescription: "Expected collection of key-value pairs; encountered odd-length array instead."
            )
          )
        }
      }

      while !container.isAtEnd {
        let key = try container.decode(Key.self)

        guard !container.isAtEnd else {
          throw DecodingError.dataCorrupted(
            DecodingError.Context(
              codingPath: decoder.codingPath,
              debugDescription: "Unkeyed container reached end before value in key-value pair."
            )
          )
        }

        let value = try container.decode(Value.self)
        self[key] = value
      }
    }
  }
}

//===----------------------------------------------------------------------===//
// Convenience Default Implementations
//===----------------------------------------------------------------------===//

// Default implementation of encodeConditional(_:forKey:) in terms of
// encode(_:forKey:)
extension KeyedEncodingContainerProtocol {
  @inlinable public mutating func encodeConditional<T: AnyObject & Encodable>(
    _ object: T,
    forKey key: Key
  ) throws {
    try encode(object, forKey: key)
  }
}

// Default implementation of encodeIfPresent(_:forKey:) in terms of
// encode(_:forKey:)
extension KeyedEncodingContainerProtocol {
  @inlinable public mutating func encodeIfPresent(
    _ value: Bool?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: String?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Double?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Float?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Int?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Int8?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Int16?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Int32?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: Int64?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: UInt?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: UInt8?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: UInt16?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: UInt32?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent(
    _ value: UInt64?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }

  @inlinable public mutating func encodeIfPresent<T: Encodable>(
    _ value: T?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
}

// Default implementation of decodeIfPresent(_:forKey:) in terms of
// decode(_:forKey:) and decodeNil(forKey:)
extension KeyedDecodingContainerProtocol {
  @inlinable public func decodeIfPresent(
    _ type: Bool.Type,
    forKey key: Key
  ) throws -> Bool? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Bool.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: String.Type,
    forKey key: Key
  ) throws -> String? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(String.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Double.Type,
    forKey key: Key
  ) throws -> Double? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Double.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Float.Type,
    forKey key: Key
  ) throws -> Float? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Float.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Int.Type,
    forKey key: Key
  ) throws -> Int? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Int.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Int8.Type,
    forKey key: Key
  ) throws -> Int8? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Int8.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Int16.Type,
    forKey key: Key
  ) throws -> Int16? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Int16.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Int32.Type,
    forKey key: Key
  ) throws -> Int32? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Int32.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: Int64.Type,
    forKey key: Key
  ) throws -> Int64? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Int64.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: UInt.Type,
    forKey key: Key
  ) throws -> UInt? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(UInt.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: UInt8.Type,
    forKey key: Key
  ) throws -> UInt8? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(UInt8.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: UInt16.Type,
    forKey key: Key
  ) throws -> UInt16? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(UInt16.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: UInt32.Type,
    forKey key: Key
  ) throws -> UInt32? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(UInt32.self, forKey: key)
  }

  @inlinable public func decodeIfPresent(
    _ type: UInt64.Type,
    forKey key: Key
  ) throws -> UInt64? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(UInt64.self, forKey: key)
  }

  @inlinable public func decodeIfPresent<T: Decodable>(
    _ type: T.Type,
    forKey key: Key
  ) throws -> T? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(T.self, forKey: key)
  }
}

// Default implementation of encodeConditional(_:) in terms of encode(_:),
// and encode(contentsOf:) in terms of encode(_:) loop.
extension UnkeyedEncodingContainer {
  @inlinable public mutating func encodeConditional<T: AnyObject & Encodable>(
    _ object: T
  ) throws {
    try self.encode(object)
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Bool {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == String {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Double {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Float {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int8 {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int16 {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int32 {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int64 {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt8 {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt16 {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt32 {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt64 {
    for element in sequence {
      try self.encode(element)
    }
  }

  @inlinable public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element: Encodable {
    for element in sequence {
      try self.encode(element)
    }
  }
}

// Default implementation of decodeIfPresent(_:) in terms of decode(_:) and
// decodeNil()
extension UnkeyedDecodingContainer {
  @inlinable public mutating func decodeIfPresent(
    _ type: Bool.Type
  ) throws -> Bool? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Bool.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: String.Type
  ) throws -> String? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(String.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: Double.Type
  ) throws -> Double? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Double.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: Float.Type
  ) throws -> Float? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Float.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: Int.Type
  ) throws -> Int? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Int.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: Int8.Type
  ) throws -> Int8? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Int8.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: Int16.Type
  ) throws -> Int16? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Int16.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: Int32.Type
  ) throws -> Int32? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Int32.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: Int64.Type
  ) throws -> Int64? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Int64.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: UInt.Type
  ) throws -> UInt? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(UInt.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: UInt8.Type
  ) throws -> UInt8? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(UInt8.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: UInt16.Type
  ) throws -> UInt16? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(UInt16.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: UInt32.Type
  ) throws -> UInt32? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(UInt32.self)
  }

  @inlinable public mutating func decodeIfPresent(
    _ type: UInt64.Type
  ) throws -> UInt64? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(UInt64.self)
  }

  @inlinable public mutating func decodeIfPresent<T: Decodable>(
    _ type: T.Type
  ) throws -> T? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(T.self)
  }
}
