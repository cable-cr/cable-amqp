# cable-amqp

This is a [Cable.cr](https://github.com/cable-cr/cable) backend extension for [cloudamqp/amqp-client.cr](https://github.com/cloudamqp/amqp-client.cr).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     cable:
       github: cable-cr/cable
     cable-amqp:
       github: cable-cr/cable-amqp
   ```

2. Run `shards install`

## Usage

```crystal
require "cable"
require "cable-amqp"

Cable.configure do |settings|
  settings.url = ENV.fetch("CABLE_BACKEND_URL", "amqp://guest:guest@localhost")
  settings.backend_class = Cable::AMQPBackend
  # ... all other Cable config settings
end
```

You can use [LavinMQ](https://lavinmq.com/) or any other AMQP supported broker.

## Development

1. Make the update
2. Add a spec and run `crystal spec`
3. Format it `crystal tool format spec/ src/`
4. Ameba `./bin/ameba`
5. Commit it
6. GO TO 1

## Contributing

1. Fork it (<https://github.com/cable-cr/cable-amqp/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jeremy Woertink](https://github.com/jwoertink) - creator and maintainer
