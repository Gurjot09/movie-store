class MoviesController < ApplicationController

  #before_action :authenticate_user!
  before_action :set_id,except:[:new,:create,:index,:detail]
  before_action :get_rating,only:[:index,:detail]
  before_action :get_view,only:[:index,:detail]

  def index
    @movies = Movie.all.order('created_at desc').limit(3)
    @movies_view = @movies_view.limit(4)
    @movies_rating = @movies_rating.limit(4)
  end

  def detail
    @view = params[:view]
  end

  def new
    @movies = Movie.new
  end

  def create
    @movies =  Movie.new(movie_params)
    if @movies.save
      redirect_to @movies,notice: "movie Successfully Saved"
    else
      render :new
    end
  end

  def show
    View.create(movie_id: @movies.id)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def movie_params
    params.require(:movie).permit(:title,:image,:genre,:plot,:rating,:web,:year,:cast)
  end

  def set_id
    @movies = Movie.find(params[:id])
  end
  def get_view
    @movies_view = Movie.select("movies.*, COUNT(*) AS group_count").joins(:views).joins("JOIN views rg on rg.movie_id = views.movie_id").group('movies.id').order('group_count DESC')
  end
  def get_rating
    @movies_rating = Movie.all.order('rating desc')
  end

end
