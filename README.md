# try.cr [![Build Status](https://travis-ci.org/maiha/try.cr.svg?branch=master)](https://travis-ci.org/maiha/try.cr)

Try monad for [Crystal](http://crystal-lang.org/).

- [crystal](http://crystal-lang.org/) : [tested versions](./ci)

## Usage

```crystal
require "try"

i = Try(Int32).try { 1 }              # => Success(Int32)
i.get                                 # => 1
i.err                                 # raises "not failed"
i.value                               # => 1
i.map(&.+ 1).value                    # => 2

i = Try(Int32).try { raise "error" }  # => Failure(Int32)
i.get                                 # raises "error"
i.err                                 # => Exception("error")
i.value                               # => Exception("error")
i.map(&.+ 1).value                    # => Exception("error")
```

## API

```crystal
def success? : Bool
def failure? : Bool
def value : T
def get : T
def get? : T?
def failed : Failure(T)
def err : Exception
def err? : Exception?
def map(&block : T -> U) : Failure(T) | Success(T) forall U
def flat_map(&block : T -> Failure(T) | Success(T)) : Failure(T) | Success(T) forall U
def recover(&block : Exception -> T) : Failure(T) | Success(T)
def or(&block : Exception -> U) : Failure(T|U) | Success(T|U) forall U
```

#### `Try.match` (experimental)

Syntax sugar for `case` statements that specialize in getting `Success` and `Failure` values like extractors in Scala.

```crystal
try = Try(Int32).try { 1 }
Try.match(try) {
  v : Success = puts "got #{v}"
  e : Failure = raise e
}
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  try:
    github: maiha/try.cr
    version: 1.6.0
```

## Development

```shell
make ci
```

## Contributing

1. Fork it ( https://github.com/maiha/try.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
