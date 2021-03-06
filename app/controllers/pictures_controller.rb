class PicturesController < ApplicationController
  before_action :move_to_index, except: [:index, :new, :show, :search, :bizarre, :alien, :uma, :myth, :ruin]
  before_action :authenticate_user!, only: :new

  impressionist :actions=> [:show]

  def index
    @pictures = Picture.includes(:user).order('created_at DESC')
  end

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new(picture_params)
    if @picture.valid?
      @picture.save
      redirect_to action: :index
    else
      render :new
    end
  end 

  def destroy
    picture = Picture.find(params[:id])
    if current_user.id == picture.user.id
      picture.destroy
      redirect_to action: :index
    else
      redirect_to action: :index
    end
  end

  def show
    @picture = Picture.find(params[:id])
    @comment = Comment.new
    @comments = @picture.comments.includes(:user).order('created_at DESC')
    impressionist(@picture, nil, unique: [:user_id])
  end

  def edit
    @picture = Picture.find(params[:id])
    redirect_to action: :index if current_user.id != @picture.user.id
  end

  def update
    @picture = Picture.find(params[:id])
    if @picture.update(picture_params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  def search
    @pictures = Picture.search(params[:keyword]).order('created_at DESC')
  end

  def bizarre
    @pictures = Picture.where(genre_id: 1).order('created_at DESC')
  end

  def alien
    @pictures = Picture.where(genre_id: 2).order('created_at DESC')
  end

  def uma
    @pictures = Picture.where(genre_id: 3).order('created_at DESC')
  end

  def myth
    @pictures = Picture.where(genre_id: 4).order('created_at DESC')
  end

  def ruin
    @pictures = Picture.where(genre_id: 5).order('created_at DESC')
  end

  private

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

  def picture_params
    params.require(:picture).permit(:image, :genre_id, :title, :text).merge(user_id: current_user.id)
  end
end
