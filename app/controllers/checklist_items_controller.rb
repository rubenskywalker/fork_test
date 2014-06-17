class ChecklistItemsController < ApplicationController
  can_edit_on_the_spot
  def create
    @checklist = Checklist.find(params[:checklist_id])
    @transaction = @checklist.transaction
    @checklist_item = @checklist.checklist_items.create( params[:checklist_item] )
  end
  
  def sort
    ChecklistItem.sort_positions!(params[:checklist_item_master])
    render nothing: true
  end
  
  def check
    @checklist_item = ChecklistItem.find(params[:id])
    checked = !@checklist_item.checked?
    @checklist_item.update_attributes( :checked => checked )
    @transaction = @checklist_item.checklist.transaction
    
    
    
    RecentActivity.create(:transaction_id => @transaction.id, 
                          :user_id =>  current_user.id, 
                          :message =>  "#{@checklist_item.checked? ? 'checked' : 'unchecked'} #{@checklist_item.name} of #{@checklist_item.checklist.checklist_master.name}")
  end
  
  def destroy
    @checklist_item = ChecklistItem.find(params[:id])
    @checklist_item.destroy
    
  end
  
end
