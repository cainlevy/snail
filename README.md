# Snail

International snail mail addressing is a pain. This gem begins to make it easier.

## Problems

The first problem when sending mail is getting it OUT of the originating country. This means writing the destination country in a manner that the originating country understands.

The second problem is getting it TO the correct address. This means writing the address lines in a manner that the destination country understands.

## Solutions

Snail relies on practical formatting guidelines gathered by [Frank's Compulsive Guide to Postal Addresses](http://www.columbia.edu/kermit/postal.html), plus internationalized country names from [The Unicode CLDR Project](http://cldr.unicode.org/index).

## Getting Started

Taking regular data and formatting it into an internationally mailable address:

```ruby
Snail.new(
  :name => "Jon Doe",
  :line_1 => "12345 Somewhere Ln",
  :line_2 => nil,
  :city => "Bentley",
  :region => "WA",
  :postal_code => "6102",
  :country => "AU"
).to_s

=> "Jon Doe\n12345 Somewhere Ln\nBENTLEY WA  6102\nAUSTRALIA"
```

By default addresses with a country of USA are considered domestic and the country will
be left off any output. To change the home country:

```ruby
Snail.home_country = "Australia"
Snail.new(
  :name => "Jon Doe",
  :line_1 => "12345 Somewhere Ln",
  :line_2 => nil,
  :city => "Bentley",
  :region => "WA",
  :postal_code => "6102",
  :country => "AU"
).to_s

=> "Jon Doe\n12345 Somewhere Ln\nBENTLEY WA  6102"
```

You can override this default behavior by specifying `with_country` as `true` or `false`:

```ruby
Snail.home_country = "Australia"
Snail.new(
  :name => "Jon Doe",
  :line_1 => "12345 Somewhere Ln",
  :line_2 => nil,
  :city => "Bentley",
  :region => "WA",
  :postal_code => "6102",
  :country => "AU"
).to_s(with_country: true)

=> "Jon Doe\n12345 Somewhere Ln\nBentley WA  6102\nAUSTRALIA"
```

See the test cases for more.

## Fun Times

The United States Postal Service (USPS) requires (strongly prefers?) a few things:

* That the address be 5 lines long or less.
* That the last address line be a country name recognized by the USPS, in all uppercase.
* That the city line (comprising the city, state, and postal code as appropriate) immediately precede the country line.

Nearly all of the variation in formatting rules applies to the city line. Depending on the receiving country, the three component pieces (e.g. city, state, postal code) have different names, are pieced together in different order with different punctuation, and may or may not be required.

And then there's Great Britain, which Frank's Compulsive Guide describes as "where to find the most confusing addresses on earth" (a description confirmed and further confused by a source from within Royal Mail).

Copyright (c) 2009-2016 Lance Ivy, released under the MIT license
