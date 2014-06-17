class TransactionTypesController < ApplicationController
  before_filter :find_tt, :except => [:index, :new, :create]
  can_edit_on_the_spot
  def index
    @transaction_types = TransactionType.all
  end

  def new
    @transaction_type = TransactionType.new
  end

  def create
    @transaction_type = TransactionType.new(params[:transaction_type])
    if @transaction_type.save
      redirect_to :back, notice: 'Transaction type was successfully created.'
    else
      render action: "new"
    end
  end
  
  def check
    checked = !@transaction_type.checked?
    @transaction_type.update_attributes( :checked => checked )
    render :nothing => true
  end

  def update_name
    @transaction_type.update_attributes(params[:name] => params[:value])
    render :nothing => true
  end
  
  def update
    if @transaction_type.update_attributes(params[:transaction_type])
      redirect_to @transaction_type, notice: 'Transaction type was successfully updated.'
    else
      render json: @transaction_type.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction_type.destroy
    redirect_to :back, notice: 'Transaction type was successfully deleted.'
  end
  
  private
  def find_tt
    @transaction_type = TransactionType.find(params[:id])
  end
  
end
