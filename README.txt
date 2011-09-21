A little library for defining little models.

Many apps use small "read only" datasets that can easily be held in memory,
for example: currency data, country data, colour data, advertising banners,
options for select boxes, payment plans etc. Sometimes it's useful to model
this data without using your database, and that's what minimodel is for.

Quick example:

  require 'minimodel'

  class Currency < MiniModel
    indexed_by :code

    insert code: 'EUR', name: 'Euro'
    insert code: 'GBP', name: 'Pound sterling'
    insert code: 'USD', name: 'United States dollar'
  end


The Currency class will respond to #count (returning the total number of
currencies), #all (returning an array of currency objects), and #find
(to lookup a specific currency by its code). Just like ActiveRecord.

Take a look at spec/*_spec.rb for more examples.

Have fun.
