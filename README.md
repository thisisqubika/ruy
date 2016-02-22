# ruy

Ruy is a library for defining a set of conditions and evaluating them against a context.

``` ruby
# discount_day.rb
gifter = Ruy::Rule.new

gifter.set :name, 'Unforgettable Fridays'

gifter.eq :friday, :day_of_week

gifter.outcome 8 do
  greater_than_or_equal 300, :amount
end

gifter.outcome 7 do
  greater_than_or_equal 100, :amount
end

gifter.outcome 3

gifter.fallback 0
```

Rules are evaluated against a context (the `Hash` being passed to `#call`) and return the first outcome that matches.

``` ruby
gifter.call(day_of_week: :friday, amount: 314)

# => 8
```

``` ruby
gifter.call(day_of_week: :friday, amount: 256)

# => 7
```

If no outcome matches, the default one is returned.
``` ruby
gifter.call(day_of_week: :friday, amount: 99)

# => 3
```

If conditions are not met, the fallback value is returned.
``` ruby
gifter.call(day_of_week: :monday, amount: 124)

# => 0
```

Retrieve rule attributes.
``` ruby
gifter.get(:name)

# => 'Unforgettable Fridays'
```

## Key concepts

Ruy at its core is about evaluating a set of conditions against a context in order to return a result.

### Conditions

A condition evaluates the state of the context.

Available conditions:

 - `all` *All of the nested conditions must suffice*
 - `any` *At least one of its nested conditions must suffice*
 - `assert` *Tests that a given context value must be a truthy value*
 - `between` *Evaluates that a given context value must belong to a specified range*
 - `cond` *At least one slice of two nested conditions must suffice*
 - `day_of_week` *Evaluates that a Date/DateTime/Time weekday is matched*
 - `dig` *Digs into a Hash allowing to define conditions over nested attributes*
 - `eq` *Tests a context value for equality*
 - `every` *Evaluates that at all the elements of a context enumerable matches the nested conditions*
 - `except` *Evaluates that a given context value is not equal to a specified value*
 - `greater_than` *Tests that a given context value is greater than something*
 - `greater_than_or_equal` *Tests that a given context value is greater than or equal to something*
 - `in` *Given context value must belong to a specified list of values*
 - `in_cyclic_order` *Expects that a given context value is included in a cyclic order*
 - `include` *The context value must include a specified value*
 - `less_than_or_equal` *Tests that a given context value is less than or equal to something*
 - `less_than` *Tests that a given context value is less than something*
 - `some` *Evaluates that at least one element of a context enumerable matches the nested conditions*

### Rules

A Rule is a set of conditions that must suffice and returns a value resulting from either an
outcome or a fallback.

### Contexts

A context is a `Hash` from which values are fetched in order to evaluate a Rule.

### Lazy values

Rules can define lazy values. The context must provide a proc which is evaluted only once the first time the value is needed. The result returned by the proc is memoized and used to evaluate subsequent conditions.


``` ruby
# premium_discount_day.rb
gifter = Ruy::Rule.new

gifter.let :amounts_average # an expensive calculation

gifter.eq :friday, :day_of_week

gifter.greater_than_or_equal 10_000, :amounts_average

gifter.outcome true
```

``` ruby
gifter.call(day_of_week: :friday, amounts_average: -> { Stats::Amounts.compute_average })
```
### Outcomes

An outcome is the result of a successful Rule evaluation. An outcome can also have nested
conditions, in such case, if the conditions meet, the outcome value is returned.

A Rule can have multiple outcomes, the first matching one is returned.

### Time Zone awareness

When it comes to matching times in different time zones, Ruy is bundled with a built in `tz` block that will enable specific matchers to make time zone-aware comparisons.

```ruby
rule = Ruy::Rule.new

rule.tz 'America/New_York' do
  eq '2015-01-01T00:00:00', :timestamp
end

rule.outcome 'Happy New Year, NYC!'
```

For example, if the timestamp provided in the context is a Ruby Time object in UTC (zero offset from UTC), `eq` as child of a `tz` block will take the time zone passed as argument to the block (`America/New_York`) to calculate the current offset and make the comparison.

String time patterns follow the Ruy's well-formed time pattern structure as follows:

`YYYY-MM-DDTHH:MM:SS[z<IANA Time Zone Database identifier>]`

Where the time zone identifier is optional, but if you specify it, will take precedence over the block's identifier. In case you don't specify it, Ruy will get the time zone from the `tz` block's argument. If neither the block nor the pattern specify it, UTC will be used.

#### Days of week matcher

Inside any `tz` block, there's a matcher to look for a specific day of the week in the time zone of the block.

```ruby
rule = Ruy::Rule.new

rule.any do
  tz 'America/New_York' do
      day_of_week :saturday, :timestamp
  end

  tz 'America/New_York' do
      day_of_week 0, :timestamp # Sunday
  end
end

rule.outcome 'Have a nice weekend, NYC!'
```

This matcher supports both the `Symbol` and number syntax in the range `(0..6)` starting on Sunday.

The day of week matcher will try to parse timestamps using the ISO8601 format unless the context passes a Time object.

#### Nested blocks support

You cannot use matchers inside nested blocks in a `tz` block expecting them to work as if they were immediate children of `tz`.

A possible workaround for this is to use `tz` blocks inside the nested block in question:

```ruby
rule = Ruy::Rule.new

rule.any do
  tz 'America/New_York' { eq '2015-01-01T00:00:00', :timestamp }
  tz 'America/New_York' { eq '2015-01-01T02:00:00zUTC', :timestamp }
end

rule.outcome 'Happy New Year, NYC!'
```

The following won't do what you expect. Instead, equality will be evaluated interpreting the time as a simple string.

```ruby
rule.tz 'America/New_York' do
  any do
    eq '2015-01-01T00:00:00', :timestamp
    eq '2015-01-01T02:00:00zUTC', :timestamp
  end
end
```

Ruy depends on [TZInfo](http://tzinfo.github.io/ "TZ Info website") to calculate offsets using IANA's Time Zone Database. Check their website for information about time zone identifiers.

### Documentation

[RubyDoc.info](http://www.rubydoc.info/github/moove-it/ruy)
