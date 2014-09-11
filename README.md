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

When it comes to matching times in different time zones, Ruy comes with a built in `tz` block that will enable specific matchers to support time zone-aware comparisons.

```ruby
ruleset = Ruy::RuleSet.new

ruleset.tz 'America/New_York' do
  eq :timestamp, '2015-01-01T00:00:00'
  outcome 'Happy New Year, NYC!'
end
```

For example, if the timestamp provided in the context is a Ruby Time object in UTC (zero offset), `eq` wrapped around `tz` will take the time zone passed as argument to the block (`America/New_York`) to calculate the current offset and make the comparison.

String time patterns follow the Ruy's well-formed time pattern structure as follows:

`YYYY-MM-DDTHH:MM:SS[z<IANA Time Zone Database identifier>]`

Where the time zone identifier is optional. In case you don't specify it, Ruy will guess the time zone from the `tz` block's argument. If none is specified, UTC will be used.

You can use any other matcher inside a `tz` block, even those that do not support time zones as of yet.

```ruby
ruleset = Ruy::RuleSet.new

ruleset.tz 'America/New_York' do
  eq :timestamp, '2015-01-01T00:00:00'
  all do
    eq :place, 'Times Square'
    greater_than :number_of_people, 1
  end
  outcome 'Happy New Year, NYC!'
end
```

Currently supported matchers inside `tz` are:
* `day_of_week`
* `eq`
* `greater_than_or_equal`
* `less_than`
* `less_than_or_equal`
* `between`

Other matchers will just behave like a standard Ruy matcher inside the block.

You cannot use matchers inside `tz` sub-blocks expecting them to work as immediate children.

```ruby
ruleset = Ruy::RuleSet.new

ruleset.tz 'America/New_York' do
  all do
    eq :timestamp, '2015-01-01T00:00:00' # Won't work because it'll compare against the String
    eq :place, 'Times Square'
    greater_than :number_of_people, 1
  end
  outcome 'Happy New Year, NYC!'
end
```

For the moment being, if you want to do something like that, you should put your sub-block's time zone-aware matchers inside another `tz` block as a workaround.

We plan to have this feature available in future versions.

Ruy relies on [TZInfo](http://tzinfo.github.io/ "TZ Info website") to calculate offsets using IANA's Time Zone Database.
