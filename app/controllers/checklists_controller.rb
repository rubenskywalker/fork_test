class ChecklistsController < ApplicationController

  before_filter :find_checklist, :except => [:index, :new, :create]

  def index
    @checklists = Checklist.all
  end


  def new
    @checklist = Checklist.new
  end

  def create
    @transaction = Transaction.find(params[:transaction_id])
    @checklist = @transaction.checklists.create(params[:checklist])
  end

  def update
    if @checklist.update_attributes(params[:checklist])
      redirect_to @checklist, notice: 'Checklist was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @checklist = Checklist.find(params[:id])
    @checklist.destroy
  end
  
  private
  def find_checklist
    @checklist = Checklist.find(params[:id])
  end
end
