import Benchmark
import InlinableCodable
import Swift
import ZippyJSON

let foo = Foo.random()
let bool = Bool.random()
let int = Int.random()
let double = Double.random()

benchmark("Encode (no inline)") {
  for _ in 1...1000 {
    let encoder = Encoder1()
    try! foo.encode(to: encoder)
    try! bool.encode(to: encoder)
    try! int.encode(to: encoder)
    try! double.encode(to: encoder)
  }
}

benchmark("Encode (inline)") {
  for _ in 1...1000 {
    let encoder = Encoder2()
    try! foo.encode(to: encoder)
    try! bool.encode(to: encoder)
    try! int.encode(to: encoder)
    try! double.encode(to: encoder)
  }
}

benchmark("Decode (no inline)") {
  for _ in 1...1000 {
    let decoder = Decoder1()
    _ = try! Bool(from: decoder)
    _ = try! Int(from: decoder)
    _ = try! String(from: decoder)
    _ = try! Foo(from: decoder)
  }
}

benchmark("Decode (inline)") {
  for _ in 1...1000 {
    let decoder = Decoder2()
    _ = try! Bool(from: decoder)
    _ = try! Int(from: decoder)
    _ = try! String(from: decoder)
    _ = try! Foo(from: decoder)
  }
}

let json = """
{
  "foo": \(Int.random()),
  "bar": "\(String.random())",
  "buz": {
    "buz1": "\(String.random())",
    "buz2": "\(String.random())",
    "buz3": "\(String.random())"
  }
}
"""
let jsonData = json.data(using: .utf8)!

benchmark("Decode json with ZippyJSONDecoder (no inline)") {
  for _ in 1...100 {
    _ = try! ZippyJSONDecoder().decode(Foo.self, from: jsonData)
  }
}

benchmark("Decode json with ZippyJSONDecoder (inline)") {
  for _ in 1...100 {
    _ = try! ZippyJSONDecoder2().decode(Foo.self, from: jsonData)
  }
}

Benchmark.main() //settings: [WarmupIterations(0), MinTime(seconds: 5)])

struct Foo: Swift.Codable, InlinableCodable.Codable {
  enum CodingKeys: CodingKey {
    case foo
    case bar
    case buz
  }

  var foo: Int
  var bar: String
  var buz: Buz

  init(foo: Int, bar: String, buz: Buz) {
    self.foo = foo
    self.bar = bar
    self.buz = buz
  }

  @inlinable
  @inline(__always)
  init(from decoder: Swift.Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.foo = try container.decode(Int.self, forKey: .foo)
    self.bar = try container.decode(String.self, forKey: .bar)
    self.buz = try container.decode(Buz.self, forKey: .buz)
  }

//  @_transparent
  @inlinable
  @inline(__always)
  init(from decoder: InlinableCodable.Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.foo = try container.decode(Int.self, forKey: .foo)
    self.bar = try container.decode(String.self, forKey: .bar)
    self.buz = try container.decode(Buz.self, forKey: .buz)
  }

  @inlinable
  @inline(__always)
  func encode(to encoder: Swift.Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.foo, forKey: .foo)
    try container.encode(self.bar, forKey: .bar)
    try container.encode(self.buz, forKey: .buz)
  }

//  @_transparent
  @inlinable
//  @inline(__always)
  func encode(to encoder: InlinableCodable.Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(foo, forKey: .foo)
    try container.encode(bar, forKey: .bar)
    try container.encode(buz, forKey: .buz)
  }

  static func random() -> Self {
    Self(
      foo: .random(),
      bar: .random(),
      buz: .random()
    )
  }
}

struct Buz: Swift.Codable, InlinableCodable.Codable {
  enum CodingKeys: CodingKey {
    case buz1, buz2, buz3
  }

  var buz1 = "a"
  var buz2 = "b"
  var buz3 = "c"

  init(buz1: String, buz2: String, buz3: String) {
    self.buz1 = buz1
    self.buz2 = buz2
    self.buz3 = buz3
  }

  @inlinable
  @inline(__always)
  init(from decoder: Swift.Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.buz1 = try container.decode(String.self, forKey: .buz1)
    self.buz2 = try container.decode(String.self, forKey: .buz2)
    self.buz3 = try container.decode(String.self, forKey: .buz3)
  }

  @inlinable
  @inline(__always)
  init(from decoder: InlinableCodable.Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.buz1 = try container.decode(String.self, forKey: .buz1)
    self.buz2 = try container.decode(String.self, forKey: .buz2)
    self.buz3 = try container.decode(String.self, forKey: .buz3)
  }

  @inlinable
  @inline(__always)
  func encode(to encoder: Swift.Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(buz1, forKey: .buz1)
    try container.encode(buz2, forKey: .buz2)
    try container.encode(buz3, forKey: .buz3)
  }

  @inlinable
  func encode(to encoder: InlinableCodable.Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(buz1, forKey: .buz1)
    try container.encode(buz2, forKey: .buz2)
    try container.encode(buz3, forKey: .buz3)
  }

  static func random() -> Self {
    Self(
      buz1: .random(),
      buz2: .random(),
      buz3: .random()
    )
  }
}
