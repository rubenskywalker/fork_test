class TransactionDetailsController < ApplicationController
  # GET /transaction_details
  # GET /transaction_details.json
  def index
    @transaction_detail = @global_company.transaction_details.first
    unless user_signed_in? && (current_user.super_admin? && !@global_company.real_free?) 
      redirect_to "/"
    else
      render :action => "edit"
    end
  end

  # GET /transaction_details/1
  # GET /transaction_details/1.json
  def show
    @transaction_detail = TransactionDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction_detail }
    end
  end

  # GET /transaction_details/new
  # GET /transaction_details/new.json
  def new
    @transaction_detail = TransactionDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction_detail }
    end
  end

  # GET /transaction_details/1/edit
  def edit
    @transaction_detail = TransactionDetail.find(params[:id])
  end

  # POST /transaction_details
  # POST /transaction_details.json
  def create
    @transaction_detail = TransactionDetail.new(params[:transaction_detail])

    respond_to do |format|
      if @transaction_detail.save
        format.html { redirect_to transaction_details_path, notice: 'Transaction detail was successfully created.' }
        format.json { render json: @transaction_detail, status: :created, location: @transaction_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @transaction_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /transaction_details/1
  # PUT /transaction_details/1.json
  def update
    @transaction_detail = TransactionDetail.find(params[:id])

    respond_to do |format|
      if @transaction_detail.update_attributes(params[:transaction_detail])
        format.html { redirect_to transaction_details_path, notice: 'Transaction detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @transaction_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_details/1
  # DELETE /transaction_details/1.json
  def destroy
    @transaction_detail = TransactionDetail.find(params[:id])
    @transaction_detail.destroy

    respond_to do |format|
      format.html { redirect_to transaction_details_url }
      format.json { head :no_content }
    end
  end
end
