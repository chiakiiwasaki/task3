class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]


  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    now = Time.current
    start_date = now.beginning_of_day
    end_date = now.end_of_day
    @books_day = @books.where(created_at: start_date..end_date).count
    yesterday_start_date = now.yesterday.beginning_of_day
    yesterday_end_date = now.yesterday.end_of_day
    @books_yesterday = @books.where(created_at: yesterday_start_date..yesterday_end_date).count
    if (@books_day != 0) && (@books_yesterday != 0)
      @difference = (@books_day.to_f/@books_yesterday.to_f).round(2)*100
    else
      @difference = "-"
    end
    start_week = now.beginning_of_week
    end_week = now.end_of_week
    @books_week = @books.where(created_at: start_week..end_week).count
    prev_start_week = now.prev_week(:monday)
    prev_end_week = now.prev_week(:sunday)
    @books_prev_week = @books.where(created_at: prev_start_week..prev_end_week).count
    if (@books_week != 0) && (@books_prev_week != 0)
      @week_difference = (@books_week.to_f/@books_prev_week.to_f).round(2)*100
    else
      @week_difference = "-"
    end
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
