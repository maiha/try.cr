# try.cr

Try monad for CrystalLang

- 0.18.x : OK
- 0.19.x : NG

## Usage

```crystal
require "try"

i = Try(Int32) { 1 }  # => Success(Int32)
i.map{|v| v + 1}      # i.value # => 2

i = Try(Int32) { raise "error" }  # => Failure(Int32)
i.map{|v| v + 1}      # NOP
i.value # => Exception("error")
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  try:
    github: maiha/try.cr
```

## Development

```shell
make test
```

## Contributing

1. Fork it ( https://github.com/maiha/try.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
