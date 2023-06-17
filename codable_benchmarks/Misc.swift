//
//  Misc.swift
//  codable_benchmarks
//
//  Created by Dmitry Galimzyanov on 18.06.2023.
//


@usableFromInline
var s: Any? = nil

@_optimize(none)
func consume<T>(_ value: __owned T) {
  s = value
}

@usableFromInline
@inline(never)
func encodeFieldName(_ name: __owned String) {
  consume(name)
}

@usableFromInline
@inline(never)
func encodeField<T>(name: __owned String, value: __owned T) {
  consume(name)
  consume(value)
}

@usableFromInline
@inline(never)
func encodeSingleValue<T>(_ value: __owned T) {
  consume(value)
}

protocol Randomable {
  static func random() -> String
}

extension String: Randomable {
  static func random() -> String {
    String(Int.random())
  }
}

extension FixedWidthInteger {
  static func random() -> Self {
    .random(in: .min...(.max))
  }
}

extension BinaryFloatingPoint where Self.RawSignificand: FixedWidthInteger {
  static func random() -> Self {
    .random(in: 0..<(.greatestFiniteMagnitude))
  }
}

@inline(never)
func decodeBool() -> Bool {
  defer { decodeStubValues.bool = !decodeStubValues.bool }
  return decodeStubValues.bool
}

@inline(never)
func decodeString() -> String {
  defer { decodeStubValues.string = String(decodeInt() as Int) }
  return decodeStubValues.string
}

@inline(never)
func decodeInt<T: FixedWidthInteger>() -> T {
  defer { decodeStubValues.int += 1 }
  return T(decodeStubValues.int)
}

@inline(never)
func decodeDouble<T: BinaryFloatingPoint>() -> T where T.RawSignificand: FixedWidthInteger {
  defer { decodeStubValues.double += 0.1 }
  return T(decodeStubValues.double)
}

var decodeStubValues: (
  bool: Bool,
  int: Int,
  string: String,
  double: Double
) = (
  bool: .random(),
  int: .random(),
  string: .random(),
  double: .random()
)
