class WidgetsController < ApplicationController
  def create
    @widget = current_user.widgets.create(params[:widget])
    redirect_to :back, notice: 'Dashboard was successfully updated.'
  end
  
  def destroy
    @widget = current_user.widgets.find(params[:id])
    @widget.destroy()
    redirect_to :back, notice: 'Dashboard was successfully updated.'
    
  end
  
  def sort
    Widget.sort_positions!(params[:widget])
    render nothing: true
  end
  
end
