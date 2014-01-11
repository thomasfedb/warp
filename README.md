# Warp

[![Build Status](https://travis-ci.org/thomasfedb/warp.png)](https://travis-ci.org/thomasfedb/warp)
[![Coverage Status](https://coveralls.io/repos/thomasfedb/warp/badge.png?branch=master)](https://coveralls.io/r/thomasfedb/warp?branch=master)
[![Gem Version](https://badge.fury.io/rb/warp.png)](http://rubygems.org/gems/warp)
[![Code Climate](https://codeclimate.com/github/thomasfedb/warp.png)](https://codeclimate.com/github/thomasfedb/warp)

RSpec Matchers to simplify writing unit and feature tests for your Rails applications.

Compatible with Ruby 1.9.2 and greater, and Rails 3.2 and greater.

## Installation

Add this line to your application's Gemfile:

    gem "warp"

And then execute:

    $ bundle

## Usage

### Controller Matchers

#### assigns(key)

Ensures that the specific assign is set:

```ruby
specify { expect(controller).to assign(:posts) }
```

#### assigns(key).with(object)

Ensures that the specific assign is set with the specified value:

```ruby
specify { expect(controller).to assign(:posts).with(posts) }
```

#### assigns(key).with_a(klass)

Ensures that the specific assign is set with an instance of the specified class:

```ruby
specify { expect(controller).to assign(:post).with_a(Post) }
```

#### assigns(key).with_a_new(klass)

Ensures that the specific assign is set with a instance of the specified class that is not persisted:

```ruby
specify { expect(controller).to assign(:post).with_a_new(Post) }
```

#### set_flash(key)

Ensure that the specific flash key is set:

```ruby
specify { expect(controller).to set_flash(:notice) }
```
#### set_flash(key).to(value)

Ensure that the specific flash key is set:

```ruby
specify { expect(controller).to set_flash(:notice).to("Your order has been processed.") }
```

### Model Matchers

#### belongs_to(key)

Ensures that a `belongs_to` association is present:

```ruby
specify { expect(comment).to belongs_to(:post) }
```

Works with either model classes or model objects.

#### have_many(key)

Ensures that a `has_many` association is present:

```ruby
specify { expect(post).to have_many(:comments) }
```

#### have_one(key)

Ensures that a `has_one` association is present:

```ruby
specify { expect(person).to have_one(:address) }
```

#### have_and_belong_to_many(key)

Ensures that a `has_and_belongs_to_many` association is present:

```ruby
specify { expect(group).to have_and_belong_to_many(:users) }
```

This matcher is not avaliable on Rails 4.1+, as these versions of Rails will create a `has_many :though` association instead of a 'has_and_belongs_to_many' association.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add your feature and specs.
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
