class RemindsController < ApplicationController

  before_action :authenticate

  #POST /create/reminds
  def create
    @remind = Remind.new(remind_params)
    @user.reminds << @remind
    respond_to do |format|
      if(@user.save)
        format.json { render json: @remind, status: :create, location: @remind }
      else
        format.json { render json: @remind.errors, status: :unprocessable_entity }
      end
    end
  end

  #GET /reminds/[:id]
  def show
    @remind = Remind.find(params[:id]) rescue nil
    respond_to do |format|
      if(@remind.nil?)
        format.json { render json: {}, status: :no_content }
      else
        format.json { render json: @remind, status: :ok }
      end
    end
  end

  #GET /reminds/users/[:user_id]
  def show_users_all
    @reminds = @user.reminds
    respond_to do |format|
      if(@reminds.nil?)
        format.json { render json: {}, status: :no_content }
      else
        format.json { render json: @reminds, status: :ok }
      end
    end
  end

  #GET /reminds/beacons/[:beacon_id]
  def show_beacons_all
    # @reminds = Remind.where(beacon_id: params[:beacon_id]) rescue nil
    @reminds = @user.reminds.where(beacon_id: params[:beacon_id]) rescue nil
    respond_to do |format|
      if(@reminds.nil?)
        format.json { render json: {}, status: :no_content }
      else
        format.json { render json: @reminds, status: :ok }
      end
    end
  end

  #PUT /reminds/[:id]
  def update
    @remind = Remind.find(params[:id]) rescue nil
    respond_to do |format|
      if @remind.nil?
        format.json { render json: { errors: { message: [ 'Can not find remind to update' ]}}, status: :not_found}
      else
        if(@remind.user_id != @user.id)
          format.json { render json: {errors: {message: ['Can not update remind']}}, status: :unauthorized }
        end
        if(@remind.update_attributes(remind_params))
          format.json { render json: @remind, status: :ok}
        else
          format.json { render json: @remind.errors, status: :unprocessable_entity}
        end
      end
    end
  end

  #DELETE /reminds/[:id]
  def destroy
    @remind = @user.reminds.find(params[:id]) rescue nil
    respond_to do |format|
        if(!@remind.nil?)
          @remind.destroy
          format.json { render json: {}, status: :ok}
        else
          format.json { render json: {errors: { message: ["Can not find remind with id: params[:id]"]}}, status: :not_found}
        end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def remind_params
    params.require(:remind).permit(:user_id, :beacon_id, :id, :content, :date_start, :date_end, :recurrence)
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @user = User.find_by_token(token)
    end
  end
end
