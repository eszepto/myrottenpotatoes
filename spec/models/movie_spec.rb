require 'factory_girl_rails'
require 'rails_helper.rb'

RSpec.describe Movie, type: :model do
  before :each do
    FactoryGirl.build(:movie , :title => 'A Fake Title ', :rating => 'PG')
    FactoryGirl.build(:movie , :title => 'Concern ', :rating => 'PG')
    FactoryGirl.build(:movie , :title => 'Barbie', :rating => 'PG')
  end
  it 'can return by title' do
    expect(Movie.sort_by_title).to eq(Movie.all.order(:title))
  end
end
