#ruy

Rules Engine for Ruby

##Introduction

Ruy is a [rules engine](http://en.wikipedia.org/wiki/Business_rules_engine) built for detecting when certain conditions obtain, and what events (or outcomes) should be trigger when they do.

A Ruy `ruleset` is a combination of `rules` that check for `conditions` and result in zero or more `outcomes`. Rulesets are loaded from an `adapter` that lets developers specify how to persist and store their rules arbitrarily.

## Example
```ruby
ruleset = Ruy::RuleSet.new

# RuleSets can use :any and :all to do AND and OR groupings of conditions.

ruleset.any do

    # RuleSets evaluate against Context variables.
    # Equality, scalarity (less than, greater
    # than or equal to, etc), and inclusion/exclusion
    # are supported

    between :age, 18, 22
    eq :school, 'University of Texas'
end

# RuleSets can have multiple outcomes when
# conditions obtain in a certain Context.

ruleset.outcome "I matched!"

ruleset.(age: 20) #=> "I matched!"
ruleset.(age: 20, school: "University of Alabama" #=> "I matched!"
ruleset.(age: 16, school: 'University of Texas' #=> "I matched!"
ruleset.(age: 10, school: 'University of Alabama') #=> nil
```

## Concepts

Ruy at its core is about evaluating something against a rule. What's a rule? And what's "something"? Let's take a look.

### Rules

A `Rule` is a set of conditions. Ruy has a number of builtin conditions:

* Equal (**:eq**)
* Assert (**:assert**)
* Between (**:between**)
* Not (**:except**)
* Inclusion (**:include** and **:included**)
* Less than/Greater than (**:less\_than**, **:less\_than\_or\_equal\_to**, **:greater\_than**, **:greater\_than\_or\_equal\_to**)

Rules can also group conditions arbitrarily as logical ANDs (**:all**) or OR (**:any**).

#### Rule-level Variables

Rules can have variables set for them. These can be procs, or just values.

```ruby
rule.var :variable_name, 'Variable Value'
```
#### Applying Rules

Rules have a `#call` method that returns true when all conditions are met. `#call` takes one argument, a `VariableContext`, that has values for the various conditions to be evaluated against. If all the conditions pass, `#call` returns `true` and otherwise `false`. Example:

```ruby
rule = Ruy::Rule.new
rule.eq :age, 21
rule.call(VariableContext.new({age: 21, name: 'Leah'}, {})) # => true
```

Cool thing about this is that by responding to `#call`, rules can do the whole `.()` syntax, or can be tested via `===`.

`VariableContext`s are Hash-like objects that resolve attributes in some context. Typically, that context is just the hash, but it could be enriched via a `Rule` or extra info.

### Outcomes

An `Outcome` is a type of rule (`class Outcome < Rule`) that emits a value when the rule is evaluated (via `#call`), instead of just returning `true`. Example:

```ruby
outcome = Ruy::Outcome.new({sample: :outcome_value})
outcome.eq :age, 21
outcome.(Ruy::VariableContext.new({age: 21}, {})) # => {sample: :outcome_value}
```

### RuleSets

A `RuleSet` also derives from `Rule`, but allows for more complex combinations of conditions and outcomes.

To repeat the initial example:

```ruby
ruleset = Ruy::RuleSet.new

ruleset.any do
  between :age, 18, 22
  eq :school, 'University of Texas'
end

ruleset.outcome "I matched!"
```

In this case, calling `ruleset.call(age: 20)` will work just fine. But we can now attach multiple outcomes (each with their own conditions), and `#call` will return the first outcome matching.

Additionally, RuleSets can have metadata associated with them, as well as a fallback value when no outcomes apply.

```ruby
ruleset = Ruy::RuleSet.new

ruleset[:description] = "Rule about checking the drinking age"
ruleset.less_than :age, 21

ruleset.outcome "Underage!"

ruleset.fallback "Nothing Matched"

ruleset.(Ruy::VariableContext.new({age: 21}, {})) # => "Nothing matched"
```

### Time Zone awareness

When it comes to matching times in different time zones, Ruy is bundled with a built in `tz` block that will enable specific matchers to make time zone-aware comparisons.

```ruby
ruleset = Ruy::RuleSet.new

ruleset.tz 'America/New_York' do
  eq :timestamp, '2015-01-01T00:00:00'
end

ruleset.outcome 'Happy New Year, NYC!'
```

For example, if the timestamp provided in the context is a Ruby Time object in UTC (zero offset from UTC), `eq` as child of a `tz` block will take the time zone passed as argument to the block (`America/New_York`) to calculate the current offset and make the comparison.

String time patterns follow the Ruy's well-formed time pattern structure as follows:

`YYYY-MM-DDTHH:MM:SS[z<IANA Time Zone Database identifier>]`

Where the time zone identifier is optional, but if you specify it, will take precedence over the block's identifier. In case you don't specify it, Ruy will get the time zone from the `tz` block's argument. If neither the block nor the pettern specify it, UTC will be used.

#### Days of week matcher

Inside any `tz` block, there's a matcher to look for a specific day of the week in the time zone of the block.

```ruby
ruleset = Ruy::RuleSet.new

ruleset.any do
  tz 'America/New_York' do
      day_of_week :timestamp, :saturday
  end

  tz 'America/New_York' do
      day_of_week :timestamp, 0 # Sunday
  end
end

ruleset.outcome 'Have a nice weekend, NYC!'
```

This matcher supports both the `Symbol` and number syntax in the range `(0..6)` starting on Sunday.

The day of week matcher will try to parse timestamps using the ISO8601 format unless the context passes a Time object.

#### Nested blocks support

You cannot use matchers inside nested blocks in a `tz` block expecting them to work as if they were immediate children of `tz`.

A possible workaround for this is to use `tz` blocks inside the nested block in question:

```ruby
ruleset = Ruy::RuleSet.new
ruleset.tz 'America/New_York' do
  any do
    tz 'America/New_York' { eq :timestamp, '2015-01-01T00:00:00' }
    tz 'America/New_York' { eq :timestamp, '2015-01-01T02:00:00zUTC' }
  end
end

ruleset.outcome 'Happy New Year, NYC!'
```

Support for time zone awareness in nested blocks inside `tz` blocks is planned. This workaround could stop working in future versions; use it at your own risk.

Ruy depends on [TZInfo](http://tzinfo.github.io/ "TZ Info website") to calculate offsets using IANA's Time Zone Database. Check their website for information about time zone identifiers.
