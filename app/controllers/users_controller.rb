class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path, notice: "Thank you for signing up!"
    else
      flash[:error] = "This user could not be created."
      render "new"
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "#{@user.proper_name} is updated."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :role, :band_id, :active, :password, :password_confirmation)  
    end

end