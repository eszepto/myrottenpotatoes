require 'rails_helper'
require 'date'

describe MoviesController do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [double('movie1'), double('movie2')]
    end
    it 'calls the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).with('hardware').
        and_return(@fake_results)
      post :search_tmdb, params: {:search_terms => 'hardware'}
    end
    describe 'after valid search' do
      before :each do
        allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
        post :search_tmdb, params: {:search_terms => 'hardware'}
      end
      it 'selects the Search Results template for rendering' do
        expect(response).to render_template('tmdb')
      end
      it 'makes the TMDb search results available to that template' do
        expect(assigns(:movies)).to eq(@fake_results)
      end
    end
  end

  describe 'Add a movie' do
    before :each do
      @fake_result = [double('movie1')]
      get :new
    end
    it 'selects the new template for rendering' do
      expect(response).to render_template('new')
      post :create, params: {
        movie: {
          :title => 'Aladdin',
          :rating => 'G',
          :release_date => '25-Nov-1992', 
          :description => 'Aladdin blah blah'
        }
      }
    end

    describe 'after add new movie' do
      before :each do
        post :create, params: {
          movie: {
            :title => 'Aladdin',
            :rating => 'G',
            :release_date => '25-Nov-1992', 
            :description => 'Aladdin blah blah'
          }
        }
      end
      it 'redirect to show template for rendering' do
        expect(response).to redirect_to(:controller => 'movies', :action => 'show', :id => 1)
      end
      it 'makes the new movie result available on that template' do
        expect(assigns(:movie)).to have_attributes(
          :title => 'Aladdin',
          :rating => 'G', 
          :release_date => DateTime.parse('25-Nov-1992'), 
          :description => 'Aladdin blah blah')
      end
    end

  end
  describe 'Edit movie' do
    
  end
  describe 'Delete movie' do
    
  end
end

