require 'rails_helper'
require 'date'

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
