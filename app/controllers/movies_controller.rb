# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def index
    sortby = params[:sort]
    if sortby
    	sort = sortby
    	session[:sort] = sort
    	if sortby == 'title'
    		@title_header_class = 'hilite'
    	elsif sortby == 'rating'
    		@rating_header_class = 'hilite'
    	elsif sortby == 'release_date'
    		@release_date_header_class = 'hilite'
    	end
    elsif session[:sort]
    	sort = session[:sort]
    	redirect = true
    else
    	sort = 'id'
    end
    ratings_allowed = params[:ratings]
    if ratings_allowed
    	if ratings_allowed.respond_to?(:keys)
    		ratings = ratings_allowed.keys
    	else
    		ratings = ratings_allowed
    	end
    	session[:ratings] = ratings
    elsif session[:ratings]
    	ratings = session[:ratings]
    	redirect = true
    else
    	ratings = Movie.ratings
    end
    if redirect
    	flash.keep
    	redirect_to movies_path(:sort => sort, :ratings => ratings)
    else
    	@movies = Movie.where(:rating => ratings).order(sort)
    	@all_ratings = Movie.ratings
    end
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
    # will render app/views/movies/show.html.haml by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
