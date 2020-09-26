class MoviesController < ApplicationController
    skip_before_action :authenticate!, only: [ :show, :index ]
    def index
        @movies = Movie.all.order(:title) 
    end

    def show
        id = params[:id]
        @movie = Movie.find(id)
    end

    def new
        @movie = Movie.new
    end

    def create
        @movie = Movie.new(movie_params)
        if @movie.save
            flash[:notice] = "#{@movie.title} was successfully created."
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
            flash[:notice] = "#{@movie.title} was successfully updated."
            redirect_to movies_path(@movie)
        else
            render 'edit'
        end
    end

    def destroy
        @movie = Movie.find params[:id]
        @movie.destroy
        flash[:notice] = "Movie #{@movie.title} deleted."
        redirect_to movies_path
    end
    
    def movie_with_filter
        @movies = Movie.with_good_reviews(params[:threshold])
        %w(for_kids with_many_fans recently_reviewed).each do |filter|
            @movies = @movies.send(filter) if params[filter] 
        end
    end

    private 
        def movie_params
            params.require(:movie).permit(:title, :rating, :release_date)
        end

end