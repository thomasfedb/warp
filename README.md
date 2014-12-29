[![Build Status](https://img.shields.io/travis/thomasfedb/warp.svg?style=flat-square)](https://travis-ci.org/thomasfedb/warp)
[![Coverage Status](https://img.shields.io/coveralls/thomasfedb/warp.svg?style=flat-square)](https://coveralls.io/r/thomasfedb/warp?branch=master)
[![Gem Version](https://img.shields.io/gem/v/warp.svg?style=flat-square)](http://rubygems.org/gems/warp)
[![Code Climate](https://img.shields.io/codeclimate/github/thomasfedb/warp.svg?style=flat-square)](https://codeclimate.com/github/thomasfedb/warp)

# Warp

Warp provides a selection of inteligent RSpec matchers for your model, controller and feature specifications.

Warp's matchers are written to be intuitive, easy to use, and to avoid testing Rails itself. The matchers also take advantage of RSpec's [composing matchers](http://www.rubydoc.info/gems/rspec-expectations/frames#Composing_Matchers) wherever possible.

Compatible with:
- Ruby 1.9.2 and greater
- Rails 3.2 and greater
- RSpec 2.99 and greater

## Installation

Add this line to your application's Gemfile:

    gem "warp"

And then execute:

    $ bundle

## Usage

### Assign Matchers

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

### Flash Matchers

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

### Association Matchers

#### belong_to(association)

Ensures that a `belong_to` association is present:

```ruby
specify { expect(comment).to belong_to(:post) }
```

Works with either model classes or model objects.

#### have_many(association)

Ensures that a `has_many` association is present:

```ruby
specify { expect(post).to have_many(:comments) }
```

#### have_one(association)

Ensures that a `has_one` association is present:

```ruby
specify { expect(person).to have_one(:address) }
```

#### have_and_belong_to_many(association)

Ensures that a `has_and_belongs_to_many` association is present:

```ruby
specify { expect(group).to have_and_belong_to_many(:users) }
```

This matcher is not avaliable on Rails 4.1+, as these versions of Rails will create a `has_many :though` association instead of a 'has_and_belongs_to_many' association.

### Attribute Matchers

#### have_attribute(attribute)

Checks if a certain attribute is present on a model. Works against models or model instances.

```ruby
specify { expect(user).to have_attribute(:name) }
```

### Validation Matchers

All validation matchers can be specified with, or without options to verify.

#### validate_acceptance_of

Ensures that a `validates_acceptance_of` validator is present on the attribute.

```ruby
specify { expect(user).to validate_acceptance_of(:terms) }
```

#### validate_absence_of

Ensures that a `validates_absence_of` validator is present on the attribute.
Only avaliable on Rails 4+.

```ruby
specify { expect(user).to validate_absence_of(:postcode, if: :non_us_address) }
```

#### validate_confirmation_of

Ensures that a `validates_confirmation_of` validator is present on the attribute.

```ruby
specify { expect(user).to validate_confirmation_of(:password) }
```

#### validate_exclusion_of

Ensures that a `validates_exclusion_of` validator is present on the attribute.

```ruby
specify { expect(user).to validate_exclusion_of(:age, in: 0..17) }
```

#### validate_format_of

Ensures that a `validates_format_of` validator is present on the attribute.

```ruby
specify { expect(user).to validate_format_of(:postcode, with: /\d{5,8}/) }
```

#### validate_inclusion_of

Ensures that a `validates_inclusion_of` validator is present on the attribute.

```ruby
specify { expect(user).to validate_inclusion_of(:role, in: ["develop", "design"]) }
```

#### validate_length_of

Ensures that a `validates_length_of` validator is present on the attribute.

```ruby
specify { expect(user).to validate_length_of(:name, in: 5..25) }
```

#### validate_numericality_of

Ensures that a `validates_numericality_of` validator is present on the attribute.

```ruby
specify { expect(user).to validate_numericality_of(:age) }
```

#### validate_presence_of

Ensures that a `validates_presence_of` validator is present on the attribute.

```ruby
specify { expect(user).to validate_presence_of(:name) }
```

#### validate_association_of

Ensures that a `validates_association_of` validator is present on the attribute.

```ruby
specify { expect(user).to validate_association_of(:profile) }
```

#### validate_uniqueness_of

Ensures that a `validates_uniqueness_of` validator is present on the attribute.

```ruby
specify { expect(user).to validate_uniqueness_of(:email, scope: :company) }
```

### Creation Matchers

#### create

Ensures that a record is created.

```ruby
specify { expect{post :create, params}.to create(Post) }
```

#### destroy

Ensures that a record is destroyed.

```ruby
specify { expect{delete :destroy, id: id}.to destroy(Post) }
```

## Contributing

1. Fork it
2. Create a branch (`git checkout -b super-foo`)
3. Add your feature and specs.
4. Commit your changes (`git commit -am 'Extra-super foo-matic.'`)
5. Push to the branch (`git push origin super-foo`)
6. Create new Pull Request
