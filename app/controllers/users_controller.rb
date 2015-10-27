class UsersController < ApplicationController

  before_action :authenticate, except: [:index, :create, :login]

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
        @user.token = SecureRandom.urlsafe_base64(nil, false)
        @user.save
        format.json { render json: @user, status: :ok, location: @user }
      else
        format.json { render json: { errors: { password: ['Wrong password'] } }, status: :unauthorized }
      end
    end
  end

  def logout
    respond_to do |format|
      if(@user.nil?)
        format.json { render json: {errors: {message: ["Can not find user with id: @user.id"]}}, status: :not_found }
      else
        @user.token = nil
        @user.save
        format.json { render json: {}, status: :ok }
      end

    end
  end

  #GET /users/[:id]
  def show
    respond_to do |format|
      if(!@user.id.to_s.eql?(params[:id]))
        format.json { render json: {errors: {message: ['Can not show user']}}, status: :unauthorized }
      end
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

  #PUT /users/:id
  def update
    respond_to do |format|
      if(!@user.id.to_s.eql?(params[:id]))
        format.json { render json: {errors: {message: ['Can not update user']}}, status: :unauthorized }
      end
      if(@user.update_attributes(user_params))
        format.json { render json: @user, status: :ok }
      else
        format.json { render json: {errors: {message: ['Something went wrong']}}, status: 500 }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:mail, :password, :id)
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @user = User.find_by_token(token)
    end
  end
end
