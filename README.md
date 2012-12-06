# BBTagCloser

Automatically detects and closes bb_tags (the ones in forums) in the opposite order that they were added.

"[u]My Underlined Text" becomes "[u]My Underlined Text[/u]"

## Installation

This gem requires Rails 3.2 or later, it was developed and tested on Rails 3.2.9

Add this line to your application's Gemfile:

    gem 'bb_tag_closer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bb_tag_closer

## Usage

  To use on a model, call close_tags. This will automatically close bb_tags on text (not string) attributes of the model. If you wish to manually specify which attributes to close bb_tags on, call close_tags_for like so:
  
  close_tags_for :attribute1, attribute2, :on => # callback you wish to close tags on, accepts validation, create, update, and save (is save by default)
  
  If the attributes are protected by mass_assignment using the :as option such as attr_accessible :my_attribute, :as => :my_permission; use close_tags or close_tags_for :attribute1, :mass_assignment_keys => :my_permission or close_tags_for :attribute1, :mass_assignment_keys => [:my_permission1, :my_permission2]
  
  BBTagCloser closes [b], [i], [u], [s], [quote], [url], [img], [email], [youtube], [size], and [color] tags by default, each is able to accept additional parameters such as [quote=foo]#...[/quote]
  To manually set the tags, call the following in an initializer file:
  
  BBTagCloser.configure { |config| config.bb_tags = ["u", "b", "s", "i", "quote", "url", "img", "email", "youtube", "size", "color", # More tags here] }

  
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
