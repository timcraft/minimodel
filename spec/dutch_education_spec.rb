require 'minimodel'
require 'minimodel/associations'
require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define(version: 1) do
  create_table :courses, force: true do |t|
    t.string :name, index: true
    t.string :level_name, index: true
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
  def level
    @level ||= Level.find(level_name)
  end
end

Level.all.each do |level|
  for course_name in %w( Nederlands Engels Duits )
    Course.create!(level_name: level.name, name: "#{level.name}/#{course_name}")
  end
end

RSpec.describe 'Level' do
  let(:level) { Level.find('VMBO-T') }

  describe '#profiles' do
    it 'returns an enumerable object with the correct size' do
      profiles = level.profiles

      expect(profiles).to respond_to(:each)
      expect(profiles.class.ancestors).to include(Enumerable)
      expect(profiles.size).to eq(4)
    end
  end

  describe '#courses' do
    it 'returns an enumerable object with the correct size' do
      courses = level.courses

      expect(courses).to respond_to(:each)
      expect(courses.class.ancestors).to include(Enumerable)
      expect(courses.size).to eq(3)
    end
  end
end

RSpec.describe 'Profile' do
  let(:profile) { Profile.find(8) }

  describe '#level' do
    it 'returns the correct level object' do
      expect(profile.level).to be_a(Level)
      expect(profile.level.name).to eq('HAVO')
    end
  end
end

RSpec.describe 'Course' do
  let(:course) { Course.find_by_name('VWO/Engels') }

  describe '#level' do
    it 'returns the correct level object' do
      expect(course.level).to be_a(Level)
      expect(course.level.name).to eq('VWO')
    end
  end
end
