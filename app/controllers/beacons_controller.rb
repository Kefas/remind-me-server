class BeaconsController < ApplicationController
  before_action :authenticate

  #POST /beacons
  def create
    @beacon = Beacon.new(beacon_params)
    @user.beacons << @beacon
    respond_to do |format|
      if @beacon.save
        format.json { render json: @beacon, status: :created}
      else
        format.json { render json: { errors: @beacon.errors }, status: :unprocessable_entity}
      end
    end
  end

  #GET /beacons
  def index
    respond_to do |format|
        format.json { render json: @user.beacons, status: :created}
    end
  end

  #GET /beacons/[:id]
  def show
    @beacon = @user.beacons.find(params[:id]) rescue nil
    respond_to do |format|
      if @beacon.nil?
        format.json { render json: @beacon, status: :no_content}
      else
        format.json { render json: @beacon, status: :ok}
      end
    end
  end

  #PUT /beacons/[:id]
  def update
    @beacon = @user.beacons.find(params[:id]) rescue nil
    respond_to do |format|
      if @beacon.nil?
        format.json { render json: @beacon, status: :not_found}
      else
        @beacon.update_attributes(beacon_params)
        format.json { render json: @beacon, status: :ok}
      end
    end
  end

  #DELETE /beacons/[:id]
  def destroy
    @beacon = @user.beacons.find(params[:id]) rescue nil
    respond_to do |format|
      if @beacon.nil?
        format.json { render json: @beacon, status: :not_found}
      else
        @beacon.destroy
        format.json { render json: {}, status: :ok}
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def beacon_params
    params.require(:beacon).permit(:uuid, :name, :id)
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @user = User.find_by_token(token)
    end
  end
end
