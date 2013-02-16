A little library for defining little models
===========================================


Installation
------------

    $ gem install minimodel


Motivation
----------

Many apps use small "read only" datasets that can easily be held in memory,
for example: currency data, country data, colour data, advertising banners,
options for select boxes, payment plans etc. Sometimes it's useful to model
this data without using a database, and that's what minimodel is for.


Example
-------

Here's how you could implement a currency model using minimodel:

```ruby
require 'minimodel'

class Currency < MiniModel
  indexed_by :code

  insert code: 'EUR', name: 'Euro'
  insert code: 'GBP', name: 'Pound sterling'
  insert code: 'USD', name: 'United States dollar'
end
```

The Currency class will respond to `#count` (returning the total number of
currencies), `#all` (returning an array of currency objects), and `#find`
(to lookup a specific currency by its code). Similar to ActiveRecord.
There's also a `load_from` class method which will load data from a YAML
file; useful for when you'd rather store the raw data outside of the class.

Take a look at `spec/*_spec.rb` for more examples. Have fun!
