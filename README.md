# Dredd

```
       .-----.
      /__ # __\
     ||  \ /  ||
     |`.  X  .'|
     | |_____| |
     `---------'
      d r e d d

Rules over collections
```

## Installation

```
$ gem install dredd
```

## Usage

Dredd is a sort of DSL, sort of rule runner, combined. 

Use it if you want to detect various outliers/exceptions within collections, detection is expressed with Dredd rules.


To start, you should have

1. A collection of hashes (if you have objects, `#to_h` them).
2. A Dredd rule.

Now combine the two :)

```ruby
result = Dredd.detect "all{ payment > 10 }.size.gt 0",
                       [
                         { :payment => 0 },
                         { :payment => 20 },
                         { :payment => 0 }
                       ]
result # => true
```

### Rules

Here's an assortment of queries possible with Dredd's DSL:

```
all.mean{ payment }
all{ payment > 10 }.sum{ payment }.is 20
first(2){ payment > 50 }
```

See live examples in `spec/dredd/query_spec.rb`


# Contributing

Fork, implement, add tests, pull request, get my everlasting thanks and a respectable place here :).

# Copyright

Copyright (c) 2014 [Dotan Nahum](http://gplus.to/dotan) [@jondot](http://twitter.com/jondot). See MIT-LICENSE for further details.

