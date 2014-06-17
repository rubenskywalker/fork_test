class TransactionStatusesController < ApplicationController
  # GET /transaction_statuses
  # GET /transaction_statuses.json
  before_filter :find_status, :except => [:index, :new, :create]
  can_edit_on_the_spot
  
  def check
    checked = !@transaction_status.checked?
    @transaction_status.update_attributes( :checked => checked )
    redirect_to :back
  end


  # GET /transaction_statuses/new
  # GET /transaction_statuses/new.json
  def new
    @transaction_status = TransactionStatus.new
  end

  def create
    @transaction_status = TransactionStatus.new(params[:transaction_status])
      if @transaction_status.save
        redirect_to :back, notice: 'Transaction status was successfully created.'
      else
        redirect_to :back, alert: 'Name of status must be unique'
      end
  end

  # PUT /transaction_statuses/1
  # PUT /transaction_statuses/1.json
  def update_name
    @transaction_status.update_attributes(params[:name] => params[:value])
    render :nothing => true
  end
  
  def update
    if @transaction_status.update_attributes(params[:transaction_status])
      redirect_to @transaction_status, notice: 'Transaction status was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @transaction_status.destroy
    redirect_to :back, notice: 'Transaction status was successfully deleted.'
  end
  
  private
  
  def find_status
    @transaction_status = TransactionStatus.find(params[:id])
  end
  
end
