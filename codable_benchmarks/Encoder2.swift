//
//  Encoder2.swift
//  codable_benchmarks
//
//  Created by Dmitry Galimzyanov on 13.06.2023.
//

import InlinableCodable

@usableFromInline
final class Encoder2: InlinableCodable.Encoder {
  @inlinable
  var codingPath: [CodingKey] { fatalError() }

  @inlinable
  var userInfo: [CodingUserInfoKey: Any] { fatalError() }

  @inlinable
  init() {}

  @inlinable
  func container<Key: CodingKey>(keyedBy _: Key.Type) -> InlinableCodable.KeyedEncodingContainer<Key> {
    InlinableCodable.KeyedEncodingContainer(_KeyedEncodingContainer2())
  }

  @inlinable
  func unkeyedContainer() -> InlinableCodable.UnkeyedEncodingContainer {
    fatalError()
  }

  @inlinable
  func singleValueContainer() -> InlinableCodable.SingleValueEncodingContainer {
    _SingleValueEncodingContainer()
  }
}

@usableFromInline
struct _KeyedEncodingContainer2<Key: CodingKey>: InlinableCodable.KeyedEncodingContainerProtocol {
  @inlinable var codingPath: [CodingKey] { fatalError() }

  @inlinable init() {}

  @inlinable
  func encodeNil(forKey _: Key) throws {
    fatalError()
  }

  @inlinable func encode(_ value: Bool, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: String, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: Double, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: Float, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: Int, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: Int8, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: Int16, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: Int32, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: Int64, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: UInt, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: UInt8, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: UInt16, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: UInt32, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode(_ value: UInt64, forKey key: Key) throws {
    encodeField(name: key.stringValue, value: value)
  }

  @inlinable func encode<T>(_ value: T, forKey key: Key) throws where T: InlinableCodable.Encodable {
    encodeFieldName(key.stringValue)
    try value.encode(to: Encoder2())
  }

  @inlinable
  func nestedContainer<NestedKey>(
    keyedBy _: NestedKey.Type,
    forKey _: Key
  ) -> InlinableCodable.KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
    fatalError()
  }

  @inlinable
  func nestedUnkeyedContainer(forKey _: Key) -> InlinableCodable.UnkeyedEncodingContainer {
    fatalError()
  }

  @inlinable
  func superEncoder() -> InlinableCodable.Encoder {
    fatalError()
  }

  @inlinable
  func superEncoder(forKey _: Key) -> InlinableCodable.Encoder {
    fatalError()
  }
}
