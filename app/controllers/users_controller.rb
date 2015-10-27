class UsersController < ApplicationController

  #registration

  # POST users#create /users(.format)
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.json { render json: @user, status: :created, location: @post}
      else
        format.json { render json: { errors: @user.errors }, status: :unprocessable_entity}
      end
    end
  end

  def login
    @user = User.find_by_mail(user_params[:mail])
    respond_to do |format|
      format.json { render json: { errors: { mail: ['Wrong mail'] } }, status: :not_found} unless !@user.nil?
      if(@user.password.eql?(user_params[:password]))
        session[:user_id] = @user.id
        format.json {render json: @user, status: :ok, location: @user}
      else
        format.json {render json: { errors: { password: ['Wrong password'] } }, status: :unauthorized}
      end
    end
  end

  def logout
    session.delete(:user_id)
    respond_to do |format|
      if(session[:user_id].nil?)
        format.json { render json: {}, status: :ok }
      else
        format.json { render json: { errors: {message: ['Can not logout']}}, status: :not_found }
      end
    end
  end

  #GET /users/[:id]
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      if(@user.nil?)
        format.json { render json: @user, status: :not_found }
      else
        format.json { render json: @user, status: :ok }
      end
    end
  end

  #GET /users
  def index
    @users = User.all
    respond_to do |format|
      if(@users.nil?)
        format.json { render json: @users, status: :not_found }
      else
        format.json { render json: @users, status: :ok }
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:mail, :password, :id)
  end

end
