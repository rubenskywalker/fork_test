class LibrariesController < ApplicationController

  load_and_authorize_resource
  can_edit_on_the_spot
  before_filter :find_library, :except => [:index, :new, :create]
  def index
    @libraries = @global_company.libraries.order("sorting ASC, name ASC")
  end
  
  def name
    @library.update_attributes(:name => params[:value])
    render :nothing => true
  end

  def new
    @library = Library.new
  end

  def create
    params[:library][:company_id] = @global_company.id
    @library = Library.new(params[:library])

    if @library.save
      redirect_to libraries_path, notice: 'Category was successfully created.'
    else
      redirect_to :back, alert: 'Category name cannot be blank.'
    end
  end

  def update
    if @library.update_attributes(params[:library])
      redirect_to libraries_path, notice: 'Category was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @library.destroy
    redirect_to libraries_url, notice: 'Category was successfully deleted.'
  end
  
  private
  def find_library
    @library = Library.find(params[:id])
  end
end
