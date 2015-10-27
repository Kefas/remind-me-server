class RemindsController < ApplicationController

  #POST /create /reminds
  def create
    @remind = Remind.new(remind_params)
    respond_to do |format|
      if(@remind.save)
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
    @remind = Remind.where(users_id: params[:users_id]) rescue nil
    respond_to do |format|
      if(@remind.nil?)
        format.json { render json: {}, status: :no_content }
      else
        format.json { render json: @remind, status: :ok }
      end
    end
  end

  #GET /reminds/beacons/[:user_id]
  def show_beacons_all
    @remind = Remind.where(beacons_id: params[:beacons_id]) rescue nil
    respond_to do |format|
      if(@remind.nil?)
        format.json { render json: {}, status: :no_content }
      else
        format.json { render json: @remind, status: :ok }
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
        if(@remind.update_attributes(remind_params))
          format.json { render json: @remind, status: :ok}
        else
          format.json { render json: @remind.errors, status: :unprocessable_entity}
        end
      end
    end
  end

  #DELETE /reminds/[:id]
  def delete
    @remind = Remind.find(params[:id]) rescue nil
    respond_to do |format|
      if(@remind.nil?)
        format.json { render json: {errors: {message: [ "Remind with id: params[:id] does not exist"]}}, status: :not_found}
      else
        @remind.destroy
        if(@remind.nil?)
          format.json { render json: {}, status: :ok}
        else
          format.json { render json: {errors: { message: ["Can not delete remind with id: params[:id]"]}}, status: 500}
        end
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def remind_params
    params.require(:remind).permit(:users_id, :beacons_id, :id, :content, :date_start, :date_end, :recurrence)
  end
end
