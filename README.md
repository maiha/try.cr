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
def err : Exception
def err? : Exception?
def failed : Try(Exception)
def foreach(&block : T -> U) : Nil
def map(&block : T -> U) : Try(U)
def flat_map(&block : T -> Try(U)) : Try(U)
def recover(&block : Exception -> T) : Try(T)
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  try:
    github: maiha/try.cr
    version: 0.4.0
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
