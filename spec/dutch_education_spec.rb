require 'minitest/autorun'
require 'minimodel'
require 'minimodel/associations'
require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define(:version => 1) do
  create_table :courses, :force => true do |t|
    t.string :name, :index => true
    t.string :level_name, :index => true
  end
end

class Level < MiniModel
  indexed_by :name

  has_many :courses
  has_many :profiles

  insert name: 'VMBO-T'
  insert name: 'HAVO'
  insert name: 'VWO'
end

class Profile < MiniModel
  indexed_by :id, auto_increment: true

  belongs_to :level

  insert level_name: 'VMBO-T', name: 'Techniek'
  insert level_name: 'VMBO-T', name: 'Zorg en Welzijn'
  insert level_name: 'VMBO-T', name: 'Economie'
  insert level_name: 'VMBO-T', name: 'Landbouw'

  insert level_name: 'HAVO', name: 'Economie en Maatschappij'
  insert level_name: 'HAVO', name: 'Cultuur en Maatschappij'
  insert level_name: 'HAVO', name: 'Natuur en Gezondheid'
  insert level_name: 'HAVO', name: 'Natuur en Techniek'

  insert level_name: 'VWO', name: 'Economie en Maatschappij'
  insert level_name: 'VWO', name: 'Cultuur en Maatschappij'
  insert level_name: 'VWO', name: 'Natuur en Gezondheid'
  insert level_name: 'VWO', name: 'Natuur en Techniek'
end

class Course < ActiveRecord::Base
end

Level.all.each do |level|
  for course_name in %w( Nederlands Engels Duits )
    Course.create!(level_name: level.name, name: "#{level.name}/#{course_name}")
  end
end

describe 'A level object' do
  before do
    @level = Level.find('VMBO-T')

    @profile_names = ['Economie', 'Landbouw', 'Techniek', 'Zorg en Welzijn']

    @course_names = %w( VMBO-T/Duits VMBO-T/Engels VMBO-T/Nederlands )
  end

  describe '#profiles' do
    it 'should be enumerable' do
      @level.profiles.must_respond_to :each
      @level.profiles.class.ancestors.must_include Enumerable
    end

    describe '#size' do
      it 'should return the number of profiles linked to this level' do
        @level.profiles.size.must_equal 4
      end
    end

    describe '#to_a' do
      it 'should return an array containing the correct profile objects' do
        profiles = @level.profiles.to_a

        profiles.must_be_kind_of Array
        profiles.map(&:name).sort.must_equal @profile_names
      end
    end
  end

  describe '#courses' do
    it 'should be enumerable' do
      @level.courses.must_respond_to :each
      @level.courses.class.ancestors.must_include Enumerable
    end

    describe '#size' do
      it 'should return the number of courses linked to this level' do
        @level.courses.size.must_equal 3
      end
    end

    describe '#to_a' do
      it 'should return an array containing the correct course objects' do
        courses = @level.courses.to_a

        courses.must_be_kind_of Array
        courses.map(&:name).sort.must_equal @course_names
      end
    end
  end
end

describe 'A profile object' do
  before do
    @profile = Profile.find(8)
  end

  describe '#level' do
    it 'should return the correct level object' do
      @profile.level.must_be_kind_of Level
      @profile.level.name.must_equal 'HAVO'
    end
  end
end
