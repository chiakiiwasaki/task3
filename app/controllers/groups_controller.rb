class GroupsController < ApplicationController

  def index
    @book = Book.new
    @group_lists = Group.all
  end

  def new
    @group = Group.new
    @group.users << current_user
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end


  private
  def group_params
    params.require(:group).permit(:name, :introduction, :image, user_ids: [])
  end
end
