//Copyright (c) 2018 Michael Eisel. All rights reserved.
// Copied from https://github.com/michaeleisel/ZippyJSON/blob/master/Sources/ZippyJSON/ZippyJSONDecoder.swift
// Modified to allow agressive inlining

import Foundation
import ZippyJSONCFamily
import JJLISO8601DateFormatter
import InlinableCodable

@usableFromInline typealias Value = JNTDecoderStorage

@usableFromInline
var _iso8601Formatter: JJLISO8601DateFormatter = {
  let formatter = JJLISO8601DateFormatter()
  formatter.formatOptions = .withInternetDateTime
  return formatter
}()

@usableFromInline
internal protocol DictionaryWithoutKeyConversion {
  static var elementType: Decodable.Type { get }
}

extension Dictionary : DictionaryWithoutKeyConversion where Key == String, Value: Decodable {
  @inlinable static var elementType: Decodable.Type { return Value.self }
}

@inlinable
func isOnSimulator() -> Bool {
#if targetEnvironment(simulator)
  return true
#else
  return false
#endif
}

public final class ZippyJSONDecoder2 {
  @available(*, deprecated, message: "This flag is deprecated because full-precision parsing speed is now on par with imprecise, so it will just always use full-precision")
  @exclusivity(unchecked) public var zjd_fullPrecisionFloatParsing = true
  private static var _zjd_suppressWarnings: Bool = false
  public static var zjd_suppressWarnings: Bool {
    get {
      return _zjd_suppressWarnings
    }
    set {
      objc_sync_enter(self)
      defer { objc_sync_exit(self) }
      _zjd_suppressWarnings = newValue
    }
  }

  @inlinable func createContext(string: UnsafePointer<Int8>, length: Int) -> ContextPointer {
    switch nonConformingFloatDecodingStrategy {
    case .convertFromString(let pI, let nI, let nan):
      return pI.withCString { pIP in
        nI.withCString { nIP in
          nan.withCString { nanP in
            return JNTCreateContext(string, UInt32(length), nIP, pIP, nanP, true)
          }
        }
      }
    case .throw:
      return JNTCreateContext(string, UInt32(length), "", "", "", false)
    }
  }

  @inlinable
  @inline(__always)
  public func decode<T : Decodable>(_ type: T.Type, from data: Data) throws -> T {
    //        if isOnSimulator() && !JNTHasVectorExtensions() {
    //          return try decodeWithAppleDecoder(type, from: data, reason: "This library was not compiled with the necessary vector extensions (this is likely because you're using SwiftPM + the simulator, and is due to limitations with SwiftPM. This does not apply to real devices.)")
    //        }
    //        if case .custom(_) = keyDecodingStrategy {
    //            return try decodeWithAppleDecoder(type, from: data, reason: "Custom key decoding is not supported, because it is uncommon and makes efficient parsing difficult")
    //        }
    return try data.withUnsafeBytes { (bytes) -> T in
      var retryReason: UnsafePointer<CChar>? = nil
      let string = bytes.baseAddress!.assumingMemoryBound(to: Int8.self)
      let context = createContext(string: string, length: data.count)
      defer {
        JNTReleaseContext(context)
      }

      var success = false
      let value = JNTDocumentFromJSON(context, bytes.baseAddress!, data.count, convertCase, &retryReason, &success)
      if success {
        let decoder = __JSONDecoder(value: value, containers: JSONDecodingStorage(), keyDecodingStrategy: keyDecodingStrategy, dataDecodingStrategy: dataDecodingStrategy, dateDecodingStrategy: dateDecodingStrategy, nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy, userInfo: userInfo)
        if JNTErrorDidOccur(context) {
          throw swiftErrorFromError(context, decoder: decoder, key: nil)
        }
        let result = try decoder.unbox(value, as: T.self, key: nil)

        if JNTErrorDidOccur(context) {
          throw swiftErrorFromError(context, decoder: decoder, key: nil)
        }
        return result
      } else {
        // Either the JSON is malformed, or the JSON is OK but it should be redone by apple.
        // If it's malformed, we could return early here, but it simplifies things to have everything do retry.
        // It will also throw Apple's version of the exception if the JSON is malformed, which looks a little
        // nicer.
        //                let retryReasonString = retryReason.map { String(utf8String: $0)! } ?? ""
        //                return try decodeWithAppleDecoder(type, from: data, reason: retryReasonString)
        fatalError()
      }
    }
  }

  @inlinable
  @inline(__always)
  func decodeWithAppleDecoder<T : Decodable>(_ type: T.Type, from data: Data, reason: String?) throws -> T {
    let appleDecoder = Foundation.JSONDecoder()
    appleDecoder.dataDecodingStrategy = Self.convertDataDecodingStrategy(dataDecodingStrategy)
    appleDecoder.dateDecodingStrategy = Self.convertDateDecodingStrategy(dateDecodingStrategy)
    appleDecoder.keyDecodingStrategy = Self.convertKeyDecodingStrategy(keyDecodingStrategy)
    appleDecoder.nonConformingFloatDecodingStrategy = Self.convertNonConformingFloatDecodingStrategy(nonConformingFloatDecodingStrategy)
    appleDecoder.userInfo = userInfo
    if !Self.zjd_suppressWarnings {
      print("[ZippyJSONDecoder] Warning: fell back to using Apple's JSONDecoder. Reason: \(reason ?? ""). This message will only be printed the first time this happens. To suppress this message entirely, for all reasons, use `ZippyJSONDecoder.zjd_suppressWarnings = true")
      Self.zjd_suppressWarnings = true
    }
    fatalError()
    //        return try appleDecoder.decode(type, from: data)
  }

  @inlinable @inline(__always)
  static func convertNonConformingFloatDecodingStrategy(_ strategy: ZippyJSONDecoder2.NonConformingFloatDecodingStrategy) -> Foundation.JSONDecoder.NonConformingFloatDecodingStrategy {
    switch strategy {
    case .convertFromString(let positiveInfinity, let negativeInfinity, let nan):
      return .convertFromString(positiveInfinity: positiveInfinity, negativeInfinity: negativeInfinity, nan: nan)
    case .throw:
      return .throw
    }
  }

  @inlinable @inline(__always)
  static func convertDateDecodingStrategy(_ strategy: ZippyJSONDecoder2.DateDecodingStrategy) -> Foundation.JSONDecoder.DateDecodingStrategy {
    switch strategy {
    case .custom(let converter):
      //            return Foundation.JSONDecoder.DateDecodingStrategy.custom(converter)
      fatalError()
    case .deferredToDate:
      return Foundation.JSONDecoder.DateDecodingStrategy.deferredToDate
    case .iso8601:
      return Foundation.JSONDecoder.DateDecodingStrategy.iso8601
    case .millisecondsSince1970:
      return Foundation.JSONDecoder.DateDecodingStrategy.millisecondsSince1970
    case .secondsSince1970:
      return Foundation.JSONDecoder.DateDecodingStrategy.secondsSince1970
    case .formatted(let formatter):
      return Foundation.JSONDecoder.DateDecodingStrategy.formatted(formatter)
    }
  }

  @inlinable @inline(__always)
  static func convertDataDecodingStrategy(_ strategy: ZippyJSONDecoder2.DataDecodingStrategy) -> Foundation.JSONDecoder.DataDecodingStrategy {
    switch strategy {
    case .base64:
      return Foundation.JSONDecoder.DataDecodingStrategy.base64
    case .custom(let converter):
      fatalError()
      //            return Foundation.JSONDecoder.DataDecodingStrategy.custom(converter)
    case .deferredToData:
      return Foundation.JSONDecoder.DataDecodingStrategy.deferredToData
    }
  }

  @inlinable @inline(__always)
  static func convertKeyDecodingStrategy(_ strategy: ZippyJSONDecoder2.KeyDecodingStrategy) -> Foundation.JSONDecoder.KeyDecodingStrategy {
    switch strategy {
    case .convertFromSnakeCase:
      return Foundation.JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
    case .useDefaultKeys:
      return Foundation.JSONDecoder.KeyDecodingStrategy.useDefaultKeys
    case .custom(let converter):
      return Foundation.JSONDecoder.KeyDecodingStrategy.custom(converter)
    }
  }


  @exclusivity(unchecked) public var userInfo: [CodingUserInfoKey : Any] = [:]

  @exclusivity(unchecked) public var nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy

  public enum NonConformingFloatDecodingStrategy {
    case `throw`
    case convertFromString(positiveInfinity: String, negativeInfinity: String, nan: String)
  }

  @exclusivity(unchecked) public var dataDecodingStrategy: DataDecodingStrategy

  public enum DataDecodingStrategy {
    case deferredToData
    case base64
    case custom((Decoder) throws -> Data)
  }

  public enum KeyDecodingStrategy {
    case useDefaultKeys
    case convertFromSnakeCase
    case custom(([CodingKey]) -> CodingKey)
  }

  @exclusivity(unchecked) public var keyDecodingStrategy: KeyDecodingStrategy

  public enum DateDecodingStrategy {
    case deferredToDate
    case secondsSince1970
    case millisecondsSince1970
    case iso8601
    case formatted(DateFormatter)
    case custom((Decoder) throws -> Date)
  }

  @exclusivity(unchecked) public var dateDecodingStrategy: DateDecodingStrategy

  @inlinable var convertCase: Bool {
    get {
      switch keyDecodingStrategy {
      case .convertFromSnakeCase:
        return true
      default:
        return false
      }
    }
  }


  @inlinable @inline(__always) public init() {
    keyDecodingStrategy = .useDefaultKeys
    dataDecodingStrategy = .base64
    dateDecodingStrategy = .deferredToDate
    nonConformingFloatDecodingStrategy = .throw
  }

  @inlinable deinit {}
}

@usableFromInline
@inline(__always) func swiftErrorFromError(_ context: ContextPointer, decoder: __JSONDecoder, key: CodingKey?) -> Error {
  var error: Error? = nil
  var errorInfo: JNTErrorInfo = JNTErrorInfo()
  JNTGetErrorInfo(context, &errorInfo)
  var path = decoder.codingPath
  if let key = key {
    path.append(key)
  }
  let debugDescription = String(utf8String: errorInfo.description!)!
  let instanceType = Any.self
  switch errorInfo.type {
  case .wrongType:
    error = DecodingError.typeMismatch(instanceType, DecodingError.Context(codingPath: path, debugDescription: debugDescription))
  case .numberDoesNotFit:
    error = DecodingError.dataCorrupted(DecodingError.Context(codingPath: path, debugDescription:debugDescription))
  case .keyDoesNotExist:
    let keyString = errorInfo.key.map { String(utf8String: $0) ?? "" } ?? ""
    let key = JSONKey(stringValue: keyString)!
    error = DecodingError.keyNotFound(key, DecodingError.Context(codingPath: path, debugDescription: debugDescription))
  case .valueDoesNotExist:
    error = DecodingError.valueNotFound(instanceType, DecodingError.Context(codingPath: path, debugDescription: debugDescription))
  case .jsonParsingFailed:
    error = DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: debugDescription))
  case .none:
    fallthrough
  @unknown default:
    break
  }
  return error ?? NSError(domain: "", code: 0, userInfo: [:])
}

@usableFromInline final class JSONDecodingStorage {
  @usableFromInline private(set) var containers: ContiguousArray<Value> = []

  @inlinable init() {
  }

  @inlinable func createCopy() -> JSONDecodingStorage {
    let copy = JSONDecodingStorage()
    copy.containers = containers
    return copy
  }

  @inlinable var topContainer: Value {
    precondition(!self.containers.isEmpty, "Empty container stack.")
    return self.containers.last!
  }

  @inlinable func push(container: Value) {
    self.containers.append(container)
  }

  @inlinable func popContainer() {
    precondition(!self.containers.isEmpty, "Empty container stack.")
    self.containers.removeLast()
  }
}

// Wrapper and AnyWrapper allow for isKnownUniquelyReferenced to work
private protocol AnyWrapper: AnyObject {
}

extension Wrapper: AnyWrapper {
}

@usableFromInline
final class Wrapper<K: CodingKey> {
  @usableFromInline var decoder: JSONKeyedDecoder<K>
  @inlinable init(decoder: JSONKeyedDecoder<K>) {
    self.decoder = decoder
  }
}

@usableFromInline
final class __JSONDecoder: Decoder {
  @usableFromInline @exclusivity(unchecked) var errorType: Any.Type? = nil
  @usableFromInline @exclusivity(unchecked) var userInfo: [CodingUserInfoKey : Any]
  @usableFromInline @exclusivity(unchecked) var codingPath: [CodingKey] = []
  @usableFromInline let value: Value
  @usableFromInline let keyDecodingStrategy: ZippyJSONDecoder2.KeyDecodingStrategy
  @usableFromInline let convertToCamel: Bool
  @usableFromInline let dataDecodingStrategy: ZippyJSONDecoder2.DataDecodingStrategy
  @usableFromInline let dateDecodingStrategy: ZippyJSONDecoder2.DateDecodingStrategy
  @usableFromInline let nonConformingFloatDecodingStrategy: ZippyJSONDecoder2.NonConformingFloatDecodingStrategy
  @usableFromInline @exclusivity(unchecked) var swiftError: Error?

  @usableFromInline var containers: JSONDecodingStorage

  @inlinable
  @inline(__always)
  init(value: Value, containers: JSONDecodingStorage, keyDecodingStrategy: ZippyJSONDecoder2.KeyDecodingStrategy, dataDecodingStrategy: ZippyJSONDecoder2.DataDecodingStrategy, dateDecodingStrategy: ZippyJSONDecoder2.DateDecodingStrategy, nonConformingFloatDecodingStrategy: ZippyJSONDecoder2.NonConformingFloatDecodingStrategy, userInfo: [CodingUserInfoKey : Any]) {
    self.value = value
    self.containers = containers
    self.keyDecodingStrategy = keyDecodingStrategy
    self.userInfo = userInfo
    if case .convertFromSnakeCase = keyDecodingStrategy {
      self.convertToCamel = true
    } else {
      self.convertToCamel = false
    }
    self.dataDecodingStrategy = dataDecodingStrategy
    self.dateDecodingStrategy = dateDecodingStrategy
    self.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
  }

  @inlinable deinit {}

  @inlinable
  func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
    // Disable caching for now
    return KeyedDecodingContainer(try JSONKeyedDecoder<Key>(decoder: self, value: containers.topContainer, convertToCamel: convertToCamel))
  }

  @inlinable func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    return try JSONUnkeyedDecoder(decoder: self, value: containers.topContainer)
  }

  @inlinable public func singleValueContainer() throws -> SingleValueDecodingContainer {
    return self
  }

  @inlinable func unboxDecimal(_ value: Value) throws -> Decimal? {
    if JNTDocumentValueIsDouble(value) {
      var length: Int32 = 0
      guard let cString = JNTDocumentDecode__DecimalString(value, &length) else { return nil }
      // Although it's mutable, in practice it won't be mutated
      let mutableCString = UnsafeMutableRawPointer(mutating: cString)
      guard let string = String(bytesNoCopy: mutableCString, length: Int(length),
                                encoding: .utf8, freeWhenDone: false) else {
        return nil
      }
      return Decimal(string: string)
    } else if JNTDocumentValueIsInteger(value) {
      let number = try unbox(value, as: Int64.self, key: nil)
      return Decimal(number)
    } else {
      throw DecodingError.typeMismatch(Any.self, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected to decode Decimal but found incorrect type instead"))
    }
  }

  @inlinable func unbox(_ value: Value, as type: Decimal.Type) throws -> Decimal {
    guard let decimal = try unboxDecimal(value) else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Invalid Decimal"))
    }
    return decimal
  }

  @inlinable
  @inline(__always)
  func push(container: Value, key: CodingKey?) {
    containers.push(container: container)
    if let key = key {
      codingPath.append(key)
    }
  }

  @inlinable
  @inline(__always)
  func pop(shouldRemoveKey: Bool) {
    containers.popContainer()
    if shouldRemoveKey {
      codingPath.removeLast()
    }
  }

  @inlinable func unbox(_ value: Value, as type: Date.Type, key: CodingKey?) throws -> Date {
    switch dateDecodingStrategy {
    case .deferredToDate:
      push(container: value, key: key)
      defer { pop(shouldRemoveKey: key != nil) }
      fatalError()
      //            return try Date(from: self)

    case .secondsSince1970:
      let double = try unbox(value, as: Double.self, key: key)
      return Date(timeIntervalSince1970: double)

    case .millisecondsSince1970:
      let double = try unbox(value, as: Double.self, key: key)
      return Date(timeIntervalSince1970: double / 1000.0)

    case .iso8601:
      let string = try self.unbox(value, as: String.self, key: key)
      guard let date = _iso8601Formatter.date(from: string) else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Expected date string to be ISO8601-formatted."))
      }
      return date
    case .formatted(let formatter):
      let string = try self.unbox(value, as: String.self, key: key)
      guard let date = formatter.date(from: string) else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Date string does not match format expected by formatter."))
      }
      return date
    case .custom(let closure):
      push(container: value, key: key)
      defer { pop(shouldRemoveKey: key != nil) }
      return try closure(self)
    }
  }

  @inlinable func unbox(_ value: Value, as type: Data.Type, key: CodingKey?) throws -> Data {
    push(container: value, key: key)
    defer { pop(shouldRemoveKey: key != nil) }
    switch dataDecodingStrategy {
    case .base64:
      let string = try unbox(value, as: String.self, key: nil)
      guard let data = Data(base64Encoded: string) else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Encountered Data is not valid Base64."))
      }
      return data
    case .deferredToData:
      fatalError()
      //            return try Data(from: self)
    case .custom(let closure):
      return try closure(self)
    }
  }

  @inlinable func unbox<T>(_ value: Value, as type: DictionaryWithoutKeyConversion.Type, key codingKey: CodingKey?) throws -> T {
    var result = [String : Any]()
    var innerError: Error?
    JNTDocumentForAllKeyValuePairs(value, { key, subValue in
      let keyString = String(cString: key!)
      do {
        result[keyString] = try self.unbox_(subValue, as: type.elementType, key: codingKey)
      } catch {
        innerError = error
      }
    })
    try throwErrorIfNecessary(value, decoder: self, key: codingKey)
    if let innerError = innerError {
      throw innerError
    }
    if let resultCasted = result as? T {
      return resultCasted
    } else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Bad dictionary"))
    }
  }

  @inlinable
  @inline(__always)
  func unbox<T : Decodable>(_ value: Value, as type: T.Type, key: CodingKey?) throws -> T {
    push(container: value, key: key)
    defer { pop(shouldRemoveKey: key != nil) }
    if T.self == Date.self || T.self == NSDate.self {
      return unsafeBitCast(try unbox(value, as: Date.self, key: nil), to: T.self)
    } else if T.self == Data.self || T.self == NSData.self {
      return unsafeBitCast(try unbox(value, as: Data.self, key: nil), to: T.self)
    } else if T.self == Decimal.self || T.self == NSDecimalNumber.self {
      return unsafeBitCast(try unbox(value, as: Decimal.self), to: T.self)
    } else if T.self == URL.self || T.self == NSURL.self {
      let urlString = try unbox(value, as: String.self, key: nil)
      guard let url = URL(string: urlString) else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                debugDescription: "Invalid URL string."))
      }
      return url as! T
    } else
    if let stringKeyedDictType = type as? DictionaryWithoutKeyConversion.Type {
      return try unbox(value, as: stringKeyedDictType, key: nil)
    } else {
      return try T(from: self)
    }
  }

  @inlinable @inline(__always)
  func unbox_(_ value: Value, as type: Decodable.Type, key: CodingKey?) throws -> Any {
    push(container: value, key: key)
    defer { pop(shouldRemoveKey: key != nil) }
    if type == Date.self || type == NSDate.self {
      return try unbox(value, as: Date.self, key: nil)
    } else if type == Data.self || type == NSData.self {
      return try unbox(value, as: Data.self, key: nil)
    } else if type == Decimal.self || type == NSDecimalNumber.self {
      return try unbox(value, as: Decimal.self)
    } else if type == URL.self || type == NSURL.self {
      let urlString = try unbox(value, as: String.self, key: nil)
      guard let url = URL(string: urlString) else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                debugDescription: "Invalid URL string."))
      }
      return url
    } else if let stringKeyedDictType = type as? DictionaryWithoutKeyConversion.Type {
      return try unbox(value, as: stringKeyedDictType, key: nil)
    } else {
      return try type.init(from: self)
    }
  }
}

extension __JSONDecoder {
  // UnboxBegin
  @inlinable @inline(__always) func unbox(_ value: Value, as type: UInt8.Type, key: CodingKey?) throws -> UInt8 {
    let result = JNTDocumentDecode__uint8_t(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: UInt16.Type, key: CodingKey?) throws -> UInt16 {
    let result = JNTDocumentDecode__uint16_t(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: UInt32.Type, key: CodingKey?) throws -> UInt32 {
    let result = JNTDocumentDecode__uint32_t(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: UInt64.Type, key: CodingKey?) throws -> UInt64 {
    let result = JNTDocumentDecode__uint64_t(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: Int8.Type, key: CodingKey?) throws -> Int8 {
    let result = JNTDocumentDecode__int8_t(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: Int16.Type, key: CodingKey?) throws -> Int16 {
    let result = JNTDocumentDecode__int16_t(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: Int32.Type, key: CodingKey?) throws -> Int32 {
    let result = JNTDocumentDecode__int32_t(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: Int64.Type, key: CodingKey?) throws -> Int64 {
    let result = JNTDocumentDecode__int64_t(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: Bool.Type, key: CodingKey?) throws -> Bool {
    let result = JNTDocumentDecode__Bool(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: String.Type, key: CodingKey?) throws -> String {
    let result = JNTDocumentDecode__String(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return String(utf8String: result!)!
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: Double.Type, key: CodingKey?) throws -> Double {
    let result = JNTDocumentDecode__Double(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: Float.Type, key: CodingKey?) throws -> Float {
    let result = JNTDocumentDecode__Float(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: Int.Type, key: CodingKey?) throws -> Int {
    let result = JNTDocumentDecode__Int(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  @inlinable @inline(__always) func unbox(_ value: Value, as type: UInt.Type, key: CodingKey?) throws -> UInt {
    let result = JNTDocumentDecode__UInt(value)
    try throwErrorIfNecessary(value, decoder: self, key: key)
    return result
  }

  // End

  @inlinable func unboxNestedUnkeyedContainer(value: Value) throws -> UnkeyedDecodingContainer {
    return try JSONUnkeyedDecoder(decoder: self, value: value)
  }

  @inlinable func unboxSuper(_ value: Value, key: CodingKey?) -> Decoder {
    push(container: value, key: key)
    defer {
      pop(shouldRemoveKey: key != nil)
    }
    return __JSONDecoder(value: value, containers: containers.createCopy(), keyDecodingStrategy: keyDecodingStrategy, dataDecodingStrategy: dataDecodingStrategy, dateDecodingStrategy: dateDecodingStrategy, nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy, userInfo: userInfo)
  }

  @inlinable func unboxNestedContainer<NestedKey>(value: Value, keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
    return KeyedDecodingContainer(try JSONKeyedDecoder<NestedKey>(decoder: self, value: value, convertToCamel: convertToCamel))
  }
}

@usableFromInline
struct IndexKey : CodingKey {
  @usableFromInline let index: Int
  @inlinable public var stringValue: String {
    return "\(index)"
  }
  @inlinable public var intValue: Int? {
    return index
  }
  @inlinable public init?(intValue: Int) {
    fatalError()
  }
  @inlinable public init?(stringValue: String) {
    fatalError()
  }
  @inlinable init(index: Int) {
    self.index = index
  }
}

@usableFromInline
internal struct JSONKey : CodingKey {
  public var stringValue: String
  public var intValue: Int?

  @inlinable init?(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = nil
  }

  @inlinable init?(intValue: Int) {
    self.stringValue = "\(intValue)"
    self.intValue = intValue
  }

  @inlinable init(stringValue: String, intValue: Int?) {
    self.stringValue = stringValue
    self.intValue = intValue
  }

  @inlinable init(index: Int) {
    self.stringValue = "Index \(index)"
    self.intValue = index
  }

  @usableFromInline static let `super` = JSONKey(stringValue: "super")!
}

@usableFromInline
struct JSONUnkeyedDecoder : UnkeyedDecodingContainer {
  @usableFromInline var currentValue: JNTDecoder
  @usableFromInline let root: JNTDecoder
  @usableFromInline var count: Int?
  @usableFromInline var iterator: JNTArrayIterator
  @usableFromInline let decoder: __JSONDecoder
  @usableFromInline var currentIndex: Int
  @inlinable var isAtEnd: Bool {
    // count is never nil in practice, so the fallback value will never be hit
    currentIndex >= (count ?? 0)
  }

  @inlinable var codingPath: [CodingKey] {
    return decoder.codingPath
  }

  @inlinable init(decoder: __JSONDecoder, value: Value) throws {
    try JSONUnkeyedDecoder.ensureValueIsArray(value: value, decoder: decoder)
    self.root = value
    self.decoder = decoder
    let count = JNTDocumentGetArrayCount(value)
    self.count = count
    self.iterator = JNTDocumentGetIterator(value)
    self.currentIndex = 0
    self.currentValue = root
  }

  @inlinable mutating func decodeNil() throws -> Bool {
    currentValue = try valueFromIterator()
    let isNil = JNTDocumentDecodeNil(currentValue)
    if isNil {
      advanceArray()
    }
    return isNil
  }

  @inlinable mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: type, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable mutating func advanceArray() {
    JNTAdvanceIterator(&iterator, root)
    currentIndex += 1
  }

  @inlinable mutating func valueFromIterator() throws -> JNTDecoder {
    if !isAtEnd {
      return JNTDecoderFromIterator(&iterator, root)
    }
    var path = codingPath
    path.append(IndexKey(index: currentIndex))
    throw DecodingError.valueNotFound(Any.self,
                                      DecodingError.Context(codingPath: path,
                                                            debugDescription: "Cannot get next value -- unkeyed container is at end."))
  }

  @inlinable static func ensureValueIsArray(value: Value, decoder: __JSONDecoder) throws {
    guard JNTDocumentValueIsArray(value) else {
      throw DecodingError.typeMismatch([Any].self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Tried to unbox array, but it wasn't an array"))
    }
  }

  @inlinable mutating public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
    currentValue = try valueFromIterator()
    let container = try decoder.unboxNestedContainer(value: currentValue, keyedBy: type)
    advanceArray()
    return container
  }

  @inlinable mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
    currentValue = try valueFromIterator()
    let container = try decoder.unboxNestedUnkeyedContainer(value: currentValue)
    advanceArray()
    return container
  }

  @inlinable mutating func superDecoder() throws -> Decoder {
    currentValue = try valueFromIterator()
    let container = decoder.unboxSuper(currentValue, key: IndexKey(index: currentIndex))
    advanceArray()
    return container
  }

  // UnkeyedBegin
  @inlinable @inline(__always) public mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: UInt8.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: UInt16.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: UInt32.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: UInt64.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: Int8.Type) throws -> Int8 {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: Int8.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: Int16.Type) throws -> Int16 {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: Int16.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: Int32.Type) throws -> Int32 {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: Int32.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: Int64.Type) throws -> Int64 {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: Int64.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: Bool.Type) throws -> Bool {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: Bool.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: String.Type) throws -> String {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: String.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: Double.Type) throws -> Double {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: Double.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: Float.Type) throws -> Float {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: Float.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: Int.Type) throws -> Int {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: Int.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  @inlinable @inline(__always) public mutating func decode(_ type: UInt.Type) throws -> UInt {
    currentValue = try valueFromIterator()
    let decoded = try decoder.unbox(currentValue, as: UInt.self, key: IndexKey(index: currentIndex))
    advanceArray()
    return decoded
  }

  // End
}

@inline(__always)
@inlinable func throwErrorIfNecessary(_ value: Value, decoder: __JSONDecoder, key: CodingKey?) throws {
  guard !JNTDocumentErrorDidOccur(value) else {
    let error = swiftErrorFromError(JNTGetContext(value), decoder: decoder, key: key)
    JNTClearError(JNTGetContext(value))
    throw error
  }
}

@usableFromInline
final class JSONKeyedDecoder<K : CodingKey> : KeyedDecodingContainerProtocol {
  @inlinable var codingPath: [CodingKey] {
    return decoder.codingPath
  }

  @usableFromInline let decoder: __JSONDecoder

  @usableFromInline typealias Key = K

  @usableFromInline @exclusivity(unchecked) var value: Value

  @usableFromInline @exclusivity(unchecked) var iterator: JNTDictionaryIterator

  @inlinable static func ensureValueIsDictionary(value: Value) throws {
    guard JNTDocumentValueIsDictionary(value) else {
      throw DecodingError.typeMismatch([Any].self, DecodingError.Context(codingPath: [], debugDescription: "Tried to unbox dictionary, but it wasn't a dictionary"))
    }
  }

  @inlinable static func setupValue(_ value: Value, decoder: __JSONDecoder, convertToCamel: Bool) throws -> Value {
    try ensureValueIsDictionary(value: value)
    // todo: fix bug where the keys get converted and then used to create a dictionary later
    if (convertToCamel) {
      JNTConvertSnakeToCamel(value)
    }
    return value
  }

  @inlinable init(decoder: __JSONDecoder, value: Value, convertToCamel: Bool) throws {
    try self.value = JSONKeyedDecoder<K>.setupValue(value, decoder: decoder, convertToCamel: convertToCamel)
    self.decoder = decoder
    self.iterator = JNTDocumentGetDictionaryIterator(value)
  }

  @inlinable deinit {}

  @inlinable var allKeys: [Key] {
    return JNTDocumentAllKeys(value).compactMap { Key(stringValue: $0) }
  }

  @inlinable func contains(_ key: K) -> Bool {
    return key.stringValue.withCString { pointer in
      return JNTDocumentContains(value, pointer, &iterator)
    }
  }

  @inlinable @inline(__always) func fetchValue(keyPointer: UnsafePointer<Int8>) throws -> Value {
    let result = JNTDocumentFetchValue(value, keyPointer, &iterator)
    try throwErrorIfNecessary(value, decoder: decoder, key: nil)
    return result
  }

  @inlinable func decodeNil(forKey key: K) throws -> Bool {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    let bool = JNTDocumentDecodeNil(subValue)
    try throwErrorIfNecessary(subValue, decoder: decoder, key: nil)
    return bool
  }

  // KeyedBegin
  @inlinable @inline(__always) func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: UInt8.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: UInt16.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: UInt32.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: UInt64.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: Int8.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: Int16.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: Int32.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: Int64.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: Bool.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: String.Type, forKey key: K) throws -> String {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: String.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: Double.Type, forKey key: K) throws -> Double {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: Double.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: Float.Type, forKey key: K) throws -> Float {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: Float.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: Int.Type, forKey key: K) throws -> Int {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: Int.self, key: key)
  }

  @inlinable @inline(__always) func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: UInt.self, key: key)
  }

  @inlinable @inline(__always) func decode<T : Decodable>(_ type: T.Type, forKey key: K) throws -> T {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unbox(subValue, as: T.self, key: key)
  }
  // End

  @inlinable func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unboxNestedContainer(value: subValue, keyedBy: type)
  }

  @inlinable func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return try decoder.unboxNestedUnkeyedContainer(value: subValue)
  }

  @inlinable func _superDecoder(forKey key: CodingKey) throws -> Decoder {
    let subValue: Value = try key.stringValue.withCString(fetchValue)
    return decoder.unboxSuper(subValue, key: key)
  }

  @inlinable func superDecoder() throws -> Decoder {
    return try _superDecoder(forKey: JSONKey.super)
  }

  @inlinable func superDecoder(forKey key: Key) throws -> Decoder {
    return try _superDecoder(forKey: key)
  }
}

extension __JSONDecoder : SingleValueDecodingContainer {
  @inlinable func decodeNil() -> Bool {
    return JNTDocumentDecodeNil(containers.topContainer)
  }

  @inlinable func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
    return try unbox(containers.topContainer, as: type, key: nil)
  }

  // SingleValueBegin
  @inlinable public func decode(_ type: UInt8.Type) throws -> UInt8 {
    return try unbox(containers.topContainer, as: UInt8.self, key: nil)
  }

  @inlinable public func decode(_ type: UInt16.Type) throws -> UInt16 {
    return try unbox(containers.topContainer, as: UInt16.self, key: nil)
  }

  @inlinable public func decode(_ type: UInt32.Type) throws -> UInt32 {
    return try unbox(containers.topContainer, as: UInt32.self, key: nil)
  }

  @inlinable public func decode(_ type: UInt64.Type) throws -> UInt64 {
    return try unbox(containers.topContainer, as: UInt64.self, key: nil)
  }

  @inlinable public func decode(_ type: Int8.Type) throws -> Int8 {
    return try unbox(containers.topContainer, as: Int8.self, key: nil)
  }

  @inlinable public func decode(_ type: Int16.Type) throws -> Int16 {
    return try unbox(containers.topContainer, as: Int16.self, key: nil)
  }

  @inlinable public func decode(_ type: Int32.Type) throws -> Int32 {
    return try unbox(containers.topContainer, as: Int32.self, key: nil)
  }

  @inlinable public func decode(_ type: Int64.Type) throws -> Int64 {
    return try unbox(containers.topContainer, as: Int64.self, key: nil)
  }

  @inlinable public func decode(_ type: Bool.Type) throws -> Bool {
    return try unbox(containers.topContainer, as: Bool.self, key: nil)
  }

  @inlinable public func decode(_ type: String.Type) throws -> String {
    return try unbox(containers.topContainer, as: String.self, key: nil)
  }

  @inlinable public func decode(_ type: Double.Type) throws -> Double {
    return try unbox(containers.topContainer, as: Double.self, key: nil)
  }

  @inlinable public func decode(_ type: Float.Type) throws -> Float {
    return try unbox(containers.topContainer, as: Float.self, key: nil)
  }

  @inlinable public func decode(_ type: Int.Type) throws -> Int {
    return try unbox(containers.topContainer, as: Int.self, key: nil)
  }

  @inlinable public func decode(_ type: UInt.Type) throws -> UInt {
    return try unbox(containers.topContainer, as: UInt.self, key: nil)
  }

  // End
}
