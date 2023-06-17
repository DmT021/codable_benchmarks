//
//  Encoder1.swift
//  codable_benchmarks
//
//  Created by Dmitry Galimzyanov on 13.06.2023.
//

import InlinableCodable
import Swift

@usableFromInline
final class Encoder1: Swift.Encoder {
  @inlinable
  var codingPath: [CodingKey] { fatalError() }

  @inlinable
  var userInfo: [CodingUserInfoKey: Any] { fatalError() }

  @inlinable
  init() {}

  @inlinable
  func container<Key: CodingKey>(keyedBy _: Key.Type) -> Swift.KeyedEncodingContainer<Key> {
    Swift.KeyedEncodingContainer(_KeyedEncodingContainer())
  }

  @inlinable
  func unkeyedContainer() -> Swift.UnkeyedEncodingContainer {
    fatalError()
  }

  @inlinable
  func singleValueContainer() -> Swift.SingleValueEncodingContainer {
    _SingleValueEncodingContainer()
  }
}

@usableFromInline
struct _KeyedEncodingContainer<Key: CodingKey>: Swift.KeyedEncodingContainerProtocol {
  @inlinable
  var codingPath: [CodingKey] { fatalError() }

  @inlinable
  init() {}

  @inlinable
  func encodeNil(forKey _: Key) throws {
    fatalError()
  }

  @inlinable
  func encode<T>(_ value: T, forKey key: Key) throws where T: Swift.Encodable {
    let name = key.stringValue
    encodeFieldName(name)
    try value.encode(to: Encoder1())
  }

  @inlinable
  func nestedContainer<NestedKey>(
    keyedBy _: NestedKey.Type,
    forKey _: Key
  ) -> Swift.KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
    fatalError()
  }

  @inlinable
  func nestedUnkeyedContainer(forKey _: Key) -> Swift.UnkeyedEncodingContainer {
    fatalError()
  }

  @inlinable
  func superEncoder() -> Swift.Encoder {
    fatalError()
  }

  @inlinable
  func superEncoder(forKey _: Key) -> Swift.Encoder {
    fatalError()
  }
}

public struct _SingleValueEncodingContainer: Swift.SingleValueEncodingContainer, InlinableCodable.SingleValueEncodingContainer {
  @inlinable public var codingPath: [CodingKey] { fatalError() }

  @inlinable public init() {}

  @inlinable public func encodeNil() throws {

  }

  @inlinable public func encode(_ value: Bool) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: String) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: Double) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: Float) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: Int) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: Int8) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: Int16) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: Int32) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: Int64) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: UInt) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: UInt8) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: UInt16) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: UInt32) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode(_ value: UInt64) throws {
    encodeSingleValue(value)
  }

  @inlinable public func encode<T>(_ value: T) throws where T : Swift.Encodable {
    try value.encode(to: Encoder1())
  }

  @inlinable public func encode<T>(_ value: T) throws where T : InlinableCodable.Encodable {
    try value.encode(to: Encoder2())
  }
}
