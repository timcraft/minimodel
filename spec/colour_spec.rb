require 'minimodel'

class Colour < MiniModel
  indexed_by :id, auto_increment: true

  insert name: 'Blue', hexdigits: '0000FF'
  insert name: 'Red', hexdigits: 'FF0000'
  insert name: 'Green', hexdigits: '00FF00'
end

RSpec.describe 'Colour' do
  it 'assigns auto incrementing id values' do
    expect(Colour.all.map(&:id).sort).to eq([1, 2, 3])
  end
end
