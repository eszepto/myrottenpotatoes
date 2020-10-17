require 'rails_helper'

describe MoviesController, :type => :controller  do
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

  describe 'manage movies' do
    before :each do
        @movie1 = FactoryGirl.create(:movie, :title => 'Test', :rating => 'R')
    end

    describe 'show all movies at homepage' do
      it 'use right templete for show all movies' do
        get :index
        expect(response).to render_template('index')
      end
    end

    describe 'add new movie' do
      
      it 'use right templete for add new movie page' do
        get :new
        expect(response).to render_template('new')
      end

      it 'can save movie and redirect to created movie page' do
        post :create, params: {:movie => {:title => 'Test 1', :rating => 'PG', :release_date => '1999-01-01', :description => ''}}
        @created_movie = Movie.last
        expect(@created_movie.title).to eq('Test 1')
        expect(@created_movie.rating).to eq('PG')
       
        expect(response).should redirect_to('/movies/%s' % (@created_movie.id))
      end 
    end

    describe 'edit movie' do
      it 'use right templete for add new movie page' do
        
        get :edit, params: {:id => @movie1.id}
        expect(response).to render_template('edit')
      end

      it 'can save movie and redirect to created movie page' do
        put :update, params: {:id => @movie1.id, :movie => {:title => 'movie Edit test', :rating => 'PG', :release_date => '1999-01-01', :description => ''}}
        @edited_movie = Movie.last
        expect(@edited_movie.title).to eq('Movie Edit Test')
        expect(@edited_movie.rating).to eq('PG')

        expect(response).should redirect_to('/movies/%s' % (@edited_movie.id))
      end 
    end
    
    describe 'delete movie' do
      it 'remove movie from database' do
        before_delete = Movie.count
        delete :destroy, params: {:id => @movie1.id}
        expect(Movie.count).to be < before_delete
      end
    end
  end
end
