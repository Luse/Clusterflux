class Admin::UsersController < Admin::MainController
   layout "admin"
  def index
    @users = Admin::User.all
  end

  def show
    @user = Admin::User.find(params[:id])
  end

  def new
    @user = Admin::User.new
  end

  def create
    @user = Admin::User.new(params[:admin_user])
    
    if @user.save
      redirect_to admin_users_path, :notice => "Successfully registered!"
    else
      render "new", :notice => "Registration failed"
    end
  end

  def edit
    @user = Admin::User.find_by_id(params[:id])
  end

  def update
    @user = Admin::User.find_by_id(params[:id])

    if @user.update_attributes(params[:admin_user])
      redirect_to user_show_path(@user.id), notice: 'Successfully updated.'
    else
      render "edit"
    end
  end

  def destroy

    @user = Admin::User.find_by_id(params[:id])

    if @current_user.id == @user.id
      logout = true
    else
      logout = false
    end

    unless @user.destroy
      redirect_to(admin_users_path, notice: "An error occured, the deletion was not successful")
    else
      #if admin removed himself, log him out
      if logout
        redirect_to(admin_log_in_path)
      else
        redirect_to(admin_users_path, notice: "An admin was deleted")
      end
    end
  end
end
