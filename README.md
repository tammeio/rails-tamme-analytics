# Tamme::Analytics


## Installation

The tamme analytics library is available on Ruby as a Ruby Gem. To install it, add this line to your application's Gemfile:

```ruby
gem 'tamme-analytics'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tamme-analytics

## USAGE
To create an instance of the Tamme analytics object:
```
tamme = Tamme::Analytics.new(write_key: 'YOUR_WRITE_KEY')
```
#### Arguments
* **write_key** : STRING : The identifier for the workspace that you're logging events for. This is available inside your tamme client dashboard.

#### Returns

All tamme methods return None

#### Exceptions

To be filled in later


## Track an Event
To track an event with tamme invoke the track method on your tamme module:

```
tamme.track(identity_id, event_name, traits)
```
#### Arguments
* **identity_id** : STRING : The identifier that you use for the user who is performing the event.
* **event_name** : STRING : Whatever you would like to call the event.
* **traits** : DICT : The arguments that you would like to send through with the event. Due to the nature of tamme there are some traits that have a special purpose:
  * **marketplace_name** : STRING : The name of the marketplace that this event relates to. (NB: the marketplace must be in the workspace identified by the write_key above)
  * **entity_type** : STRING : what type of entity is this, this should match up with an entity name that you have defined inside the tamme dashboard
  * **category** : STRING : which category does the event relate to, this has to be a category that you have defined within a marketplace in the tamme dashboard
  * **lat** : STRING : the latitude that the event relates to, as a decimal
  * **lng** : STRING : the longitude that the event relates to, as a decimal
  * **postcode** : STRING : the postal code, or zip code, that the event is relates to
  * **country** : STRING : the country in which the event has occurred
  * **counterpart_id** : STRING : if the event occurs between two users, for example; one interacts with the other, then you can add in the id of the other user here in order to define the relationship. This can be handy when trying to trigger notifications, or define segmentation parameters and also helps to teach tamme which users are most likely to interact on the system so that it can better learn how to predict the most effective outreach

#### Returns

All tamme methods return None

#### Exceptions

To be filled in later

#### Example

In this example the user is identified as having conducted a search as a business looking for waitstaff in 3181, AU. There are also extra traits for radius and business_name for analytics reference only.

```
tamme.track(

    "398u4-re98r-3498rw-34r9u",

    "Added Search",

    {

        "marketplace_name" : "Skilld",

        "entity_type" : "business",

        "category" : "waitstaff",

        "postcode" : "3181",

        "country" : "AU",

        "radius" : "5",

        "business_name" : "Maria's Mediterranean Meats"

    }

)
```

## Identify a User

Identifying a user allows tamme to understand who is undertaking what actions which gives it the power to measure, learn and report at a user by user level. Identifying a user can is as simple as:

```
tamme.identify(identity_id, traits)
```

#### Arguments
* **identity_id** : STRING : The identifier that you use for the user who is performing the event.
* **traits** : DICT : The arguments that you would like to send through with the event. Due to the nature of tamme there are some fields that are used for particular functions:
  * **email**: STRING :
  * **mobile** : STRING :
  * **unsubscribed** : BOOLEAN : This will unsubscribe a person from all communication from your marketplace
  * **resubscribed** : BOOLEAN : This will trigger the re-subscription script for all communication preferences
  * **unsubscribed_sms** : BOOLEAN : This will unsubscribe a person from sms communication from your marketplace
  * **resubscribed_sms** : BOOLEAN : This will trigger the re-subscription script for sms communication preferences
  * **unsubscribed_email** : BOOLEAN : This will unsubscribe a person from email communication from your marketplace
  * **resubscribed_email** : BOOLEAN : This will trigger the re-subscription script for email communication preferences
  * **unsubscribed_push** : BOOLEAN : This will unsubscribe a person from push notifications from your marketplace
  * **resubscribed_push** : BOOLEAN : This will trigger the re-subscription script for push notification preferences

#### Returns

All tamme methods return None

#### Exceptions

To be filled in upon completion

#### Example
In this example the person is identified and some basic personal details are sent through
```
tamme.identify(

    "398u4-re98r-3498rw-34r9u",

    {

        "email" : "person@example.com",

        "mobile" : "61412987364",

        "name" : "Jane Doe",

        "favourite_color" : "blue"

    }

)
```

## Connect Two People Together
Sometimes you can have two identifiers for one user, for instance if you are merging user accounts together. Tamme provides a method called 'alias' that tells the system that two users are the same person which can be called like this:

```
tamme.alias(new_id, old_id)
```

#### Arguments

* **new_id** : STRING : The new identifier that you want to use to identify the user. This identifier will be the active identifier moving forward.
* **old_id** : STRING : The previous identifier that you used to identify the user. This identifier will now be considered dormant.

#### Returns

All tamme methods return None

#### Exceptions

To be filled in upon completion

#### Example

This example shows a simple alias through the tamme library. The person would originally have been identified as "398u4-re98r-3498rw-34r9u" and will be identified in the future as "34r90kd-34098-45tr-sdfd".
```
tamme.alias(

    "398u4-re98r-3498rw-34r9u",

    "34r90kd-34098-45tr-sdfd"

)
```

## Send the Events through to tamme

Once you have triggered the events that you would like to record you can call the 'flush' method to have them sent to the tamme analytics collections servers.

```
tamme.flush
```

#### Arguments

There are no arguments required for the flush command

#### Returns

All tamme methods return None

#### Exceptions

To be filled out upon completion

#### Example
```
tamme.flush
```





## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tamme-analytics. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tamme::Analytics project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tamme-analytics/blob/master/CODE_OF_CONDUCT.md).
