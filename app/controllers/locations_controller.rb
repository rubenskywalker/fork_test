class LocationsController < ApplicationController
  # GET /locations
  # GET /locations.json
  before_filter :global_admin_access, :only => [:index]
  before_filter :find_location, :except => [:index, :new, :create]
  can_edit_on_the_spot
  def index
    @locations = @global_company.locations
    
  end

  
  def name
    @location.update_attributes(params[:name] => params[:value])
    render :nothing => true
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new
  end

  def create
    params[:location][:company_id] = @global_company.id
    @location = Location.new(params[:location])

    if @location.save
      redirect_to locations_path, notice: 'Location was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @location.update_attributes(params[:location])
      redirect_to @location, notice: 'Location was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    
    @location.destroy

    redirect_to locations_url, notice: 'Location was successfully deleted.'
  end
  
  private
  def find_location
    @location = Location.find(params[:id])
  end
  
end
