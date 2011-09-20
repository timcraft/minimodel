require 'minitest/autorun'
require 'minimodel'

class Colour < MiniModel
  indexed_by :id, auto_increment: true

  insert name: 'Blue', hexdigits: '0000FF'
  insert name: 'Red', hexdigits: 'FF0000'
  insert name: 'Green', hexdigits: '00FF00'
end

describe Colour do
  it 'should assign auto incrementing id values' do
    Colour.all.map(&:id).must_equal [1, 2, 3]
  end
end
