class MoviesController < ApplicationController
    skip_before_action :authenticate!#, only: [ :show, :index, :search_tmdb]


    def index
        @movies = Movie.all.order(:title) 
    end

    def show
        id = params[:id]
        @movie = Movie.find(id)
        if @current_user
            @review = @movie.reviews.find_by(:moviegoer_id => @current_user.id)
        end
        render(:partial => 'movie_popup', :object=>@movie) if request.xhr?
    end

    def new 
        @movie = Movie.new
    end

    def create
        @movie = Movie.new(movie_params)
        if @movie.save
            flash[:notice] = "'#{@movie.title}' was successfully created."
            redirect_to movie_path(@movie)
        else
            render 'new'
        end
    end

    def edit
        @movie = Movie.find params[:id]
    end

    def update
        @movie = Movie.find params[:id]
        if @movie.update(movie_params) 
            flash[:notice] = "'#{@movie.title}' was successfully updated."
            redirect_to movie_path(@movie)
        else
            render 'edit'
        end
    end

    def destroy
        @movie = Movie.find params[:id]
        @movie.destroy
        flash[:notice] = "Movie '#{@movie.title}' deleted."
        redirect_to movies_path
    end
    
    def movie_with_filter
        @movies = Movie.with_good_reviews(params[:threshold])
        %w(for_kids with_many_fans recently_reviewed).each do |filter|
            @movies = @movies.send(filter) if params[filter] 
        end
    end

    def search_tmdb
        @search_terms = params[:search_terms]
        @movies = Movie.find_in_tmdb(@search_terms)
        if @movies
            render 'tmdb'
        else
            flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
            redirect_to movies_path
        end 
    end

    def create_from_tmdb
        movie_id = params[:tmdb_id]
        m = Movie.get_from_tmdb(movie_id)
        @movie = Movie.new({
            :title => m["title"], 
            :rating => "",    
            :release_date => m["release_date"], 
            :description => m["overview"]
            })
        if @movie.save
            flash[:notice] = "'#{@movie.title}' was successfully created."
            redirect_to movie_path(@movie)
        end
    end

    private 
        def movie_params
            params.require(:movie).permit(:title, :rating, :release_date, :description)
        end

end