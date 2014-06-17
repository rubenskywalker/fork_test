class ChecklistMastersController < ApplicationController
  # GET /checklist_masters
  # GET /checklist_masters.json
  load_and_authorize_resource
  before_filter :global_admin_access, :only => [:index]
  before_filter :find_checklist_master, :only => [:show, :edit, :update, :destroy]
  
  def index
    @checklist_masters = @global_company.checklist_masters
  end

  def sort
    ChecklistMaster.sort_positions!(params[:checklist_master])
    render nothing: true
  end
  

  def new
    @checklist_master = ChecklistMaster.new(:company_id => @global_company.id)
    @checklist_master.checklist_item_masters.build
    #@checklist_master.checklist_item_masters.build
    #@checklist_master.checklist_item_masters.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @checklist_master }
    end
  end

  def create
    @checklist_master = ChecklistMaster.new(params[:checklist_master].merge!(company_id: @global_company.id))

    respond_to do |format|
      if @checklist_master.save
        format.html { redirect_to checklist_masters_path, notice: 'Checklist was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  
  
  def update
    respond_to do |format|

      if @checklist_master.update_attributes(params[:checklist_master])
        format.html { redirect_to checklist_masters_path, notice: 'Checklist was successfully updated.' }
      else
        format.html { render action: "edit" }
      end

    end
  end

  # DELETE /checklist_masters/1
  # DELETE /checklist_masters/1.json
  
  def destroy
    @checklist_master.destroy

    respond_to do |format|
      format.html { redirect_to checklist_masters_url, notice: 'Checklist was successfully deleted.' }
    end
  end
  
  private
  
  def find_checklist_master
    @checklist_master = ChecklistMaster.find(params[:id])
  end
end
