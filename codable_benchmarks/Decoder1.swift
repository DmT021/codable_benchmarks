//
//  Decoder1.swift
//  codable_benchmarks
//
//  Created by Dmitry Galimzyanov on 14.06.2023.
//

final class Decoder1: Decoder {
  @inlinable init() {}

  @inlinable var codingPath: [CodingKey] { fatalError() }

  @inlinable var userInfo: [CodingUserInfoKey : Any] { fatalError() }

  @inlinable func container<Key>(keyedBy type: Key.Type) throws -> Swift.KeyedDecodingContainer<Key> where Key : CodingKey {
    KeyedDecodingContainer(_KeyedDecodingContainer1())
  }

  @inlinable func unkeyedContainer() throws -> Swift.UnkeyedDecodingContainer {
    _UnkeyedDecodingContainer1()
  }

  @inlinable func singleValueContainer() throws -> Swift.SingleValueDecodingContainer {
    _SingleValueDecodingContainer1()
  }
}

struct _KeyedDecodingContainer1<Key: CodingKey>: KeyedDecodingContainerProtocol {
  @inlinable init() {}

  @inlinable var allKeys: [Key] { fatalError() }

  @inlinable func contains(_ key: Key) -> Bool {
    fatalError()
  }

  @inlinable func decodeNil(forKey key: Key) throws -> Bool {
    decodeBool()
  }

  @inlinable func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
    decodeBool()
  }

  @inlinable func decode(_ type: String.Type, forKey key: Key) throws -> String {
    decodeString()
  }

  @inlinable func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
    decodeDouble()
  }

  @inlinable func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
    decodeDouble()
  }

  @inlinable func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
    decodeInt()
  }

  @inlinable func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
    decodeInt()
  }

  @inlinable func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
    decodeInt()
  }

  @inlinable func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
    decodeInt()
  }

  @inlinable func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
    decodeInt()
  }

  @inlinable func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
    decodeInt()
  }

  @inlinable func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
    decodeInt()
  }

  @inlinable func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
    decodeInt()
  }

  @inlinable func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
    decodeInt()
  }

  @inlinable func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
    decodeInt()
  }

  @inlinable func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Swift.Decodable {
    try T(from: Decoder1())
  }

  @inlinable func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> Swift.KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
    KeyedDecodingContainer(_KeyedDecodingContainer1<NestedKey>())
  }

  @inlinable func nestedUnkeyedContainer(forKey key: Key) throws -> Swift.UnkeyedDecodingContainer {
    _UnkeyedDecodingContainer1()
  }

  @inlinable func superDecoder(forKey key: Key) throws -> Swift.Decoder {
    fatalError()
  }

  @inlinable var codingPath: [CodingKey] { fatalError() }

  @inlinable func superDecoder() throws -> Swift.Decoder {
    fatalError()
  }
}

struct _UnkeyedDecodingContainer1: UnkeyedDecodingContainer {
  @inlinable init() {}

  @inlinable var codingPath: [CodingKey] { fatalError() }

  @inlinable var count: Int? { nil }

  @inlinable var isAtEnd: Bool { currentIndex < 10 }

  var currentIndex = 0

  @inlinable mutating func _pop<T: FixedWidthInteger>() -> T {
    currentIndex += 1
    return decodeInt()
  }

  @inlinable mutating func _pop<T: BinaryFloatingPoint>() -> T where T.RawSignificand: FixedWidthInteger {
    currentIndex += 1
    return decodeDouble()
  }

  @inlinable mutating func _pop() -> String {
    currentIndex += 1
    return decodeString()
  }

  @inlinable mutating func _pop() -> Bool {
    currentIndex += 1
    return decodeBool()
  }

  @inlinable mutating func decodeNil() throws -> Bool {
    _pop()
  }

  @inlinable mutating func decode(_ type: Bool.Type) throws -> Bool {
    _pop()
  }

  @inlinable mutating func decode(_ type: String.Type) throws -> String {
    _pop()
  }

  @inlinable mutating func decode(_ type: Double.Type) throws -> Double {
    _pop()
  }

  @inlinable mutating func decode(_ type: Float.Type) throws -> Float {
    _pop()
  }

  @inlinable mutating func decode(_ type: Int.Type) throws -> Int {
    _pop()
  }

  @inlinable mutating func decode(_ type: Int8.Type) throws -> Int8 {
    _pop()
  }

  @inlinable mutating func decode(_ type: Int16.Type) throws -> Int16 {
    _pop()
  }

  @inlinable mutating func decode(_ type: Int32.Type) throws -> Int32 {
    _pop()
  }

  @inlinable mutating func decode(_ type: Int64.Type) throws -> Int64 {
    _pop()
  }

  @inlinable mutating func decode(_ type: UInt.Type) throws -> UInt {
    _pop()
  }

  @inlinable mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
    _pop()
  }

  @inlinable mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
    _pop()
  }

  @inlinable mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
    _pop()
  }

  @inlinable mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
    _pop()
  }

  @inlinable mutating func decode<T>(_ type: T.Type) throws -> T where T : Swift.Decodable {
    try T(from: Decoder1())
  }

  @inlinable mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> Swift.KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
    KeyedDecodingContainer(_KeyedDecodingContainer1())
  }

  @inlinable mutating func nestedUnkeyedContainer() throws -> Swift.UnkeyedDecodingContainer {
    _UnkeyedDecodingContainer1()
  }

  @inlinable mutating func superDecoder() throws -> Swift.Decoder {
    fatalError()
  }
}

struct _SingleValueDecodingContainer1: SingleValueDecodingContainer {
  @inlinable init() {}

  @inlinable var codingPath: [CodingKey] { fatalError() }

  @inlinable func decodeNil() -> Bool {
    decodeBool()
  }

  @inlinable func decode(_ type: Bool.Type) throws -> Bool {
    decodeBool()
  }

  @inlinable func decode(_ type: String.Type) throws -> String {
    decodeString()
  }

  @inlinable func decode(_ type: Double.Type) throws -> Double {
    decodeDouble()
  }

  @inlinable func decode(_ type: Float.Type) throws -> Float {
    decodeDouble()
  }

  @inlinable func decode(_ type: Int.Type) throws -> Int {
    decodeInt()
  }

  @inlinable func decode(_ type: Int8.Type) throws -> Int8 {
    decodeInt()
  }

  @inlinable func decode(_ type: Int16.Type) throws -> Int16 {
    decodeInt()
  }

  @inlinable func decode(_ type: Int32.Type) throws -> Int32 {
    decodeInt()
  }

  @inlinable func decode(_ type: Int64.Type) throws -> Int64 {
    decodeInt()
  }

  @inlinable func decode(_ type: UInt.Type) throws -> UInt {
    decodeInt()
  }

  @inlinable func decode(_ type: UInt8.Type) throws -> UInt8 {
    decodeInt()
  }

  @inlinable func decode(_ type: UInt16.Type) throws -> UInt16 {
    decodeInt()
  }

  @inlinable func decode(_ type: UInt32.Type) throws -> UInt32 {
    decodeInt()
  }

  @inlinable func decode(_ type: UInt64.Type) throws -> UInt64 {
    decodeInt()
  }

  @inlinable func decode<T>(_ type: T.Type) throws -> T where T : Swift.Decodable {
    try T(from: Decoder1())
  }
}
