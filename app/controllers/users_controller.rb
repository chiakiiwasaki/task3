class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]


  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    now = Time.current
    @item6 = @books.where(created_at: (now-6.day).at_beginning_of_day..(now-6.day).at_end_of_day).count
    @item5 = @books.where(created_at: (now-5.day).at_beginning_of_day..(now-5.day).at_end_of_day).count
    @item4 = @books.where(created_at: (now-4.day).at_beginning_of_day..(now-4.day).at_end_of_day).count
    @item3 = @books.where(created_at: (now-3.day).at_beginning_of_day..(now-3.day).at_end_of_day).count
    @item2 = @books.where(created_at: (now-2.day).at_beginning_of_day..(now-2.day).at_end_of_day).count
    @item1 = @books.where(created_at: (now-1.day).at_beginning_of_day..(now-1.day).at_end_of_day).count
    @item0 = @books.where(created_at: now.at_beginning_of_day..now.at_end_of_day).count
    gon.data = @item6, @item5, @item4, @item3, @item2, @item1, @item0
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def following
    @title = "Follow Users"
    @user  = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = "Follower Users"
    @user  = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end


  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
