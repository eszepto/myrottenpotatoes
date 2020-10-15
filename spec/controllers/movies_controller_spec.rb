require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
    
    it 'calls the model method that performs TMDb search' do
      post :search_tmdb, params: {:search_terms => 'hardware'}

    end
    describe 'after valid search' do
      before :each do
        post :search_tmdb, params: {:search_terms => 'hardware'}

      end
      it 'selects the Search Results template for rendering' do
        expect(response).to render_template('movies/tmdb')
      end
      it 'makes the TMDb search results available to that template' do
        
      end
    end
  end
  describe 'manage movie' do
      
  end
end