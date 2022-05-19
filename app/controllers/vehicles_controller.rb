class VehiclesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  # before_action :set_vehicle, only: [:show]

  def index
    @vehicles = policy_scope(Vehicle)
    @markers = @vehicles.geocoded.map do |vehicle|
      {
        lat: vehicle.latitude,
        lng: vehicle.longitude,
        # info_window: render_to_string(partial: "info_window", locals: { flat: flat })
      }
    end
  end

  def show
    @booking = Booking.new
    @vehicle = Vehicle.find(params[:id])
    authorize @vehicle
  end

  def new
    @vehicle = Vehicle.new
    authorize @vehicle
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.user = current_user
    authorize @vehicle

    if @vehicle.save
      redirect_to vehicle_path(@vehicle)
    else
      render :new
    end
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(:brand, :model, :category, :description, :price, :location, :photo)
  end

  # def set_vehicle
  #   @vehicle = Vehicle.find(params[:id])
  #   authorize @vehicle
  # end
end
