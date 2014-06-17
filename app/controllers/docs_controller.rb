class DocsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:show_file, :show_png, :reload]
  before_filter :load_commentable, :except => [:reload, :left, :right, :flip, :upload_process, :after_upload, :move_to_checklist_items, :review, :show_file, :show_png]
  
  def create
    filename = params[:file].original_filename
    incompatible = false
    if filename.include?("/") || filename.include?("\\") || filename.include?("<") || filename.include?(">") || filename.include?(":") || filename.include?('"') || filename.include?("|") || filename.include?("?") || filename.include?("*")
      incompatible = true
    end
    @file = @docable.docs.create(:file => params[:file], :user_id => current_user.id, :incompatible => incompatible, :alias => filename)
    if @docable.class.name == 'ChecklistItem'
      @docable.doc_accesses.find_by_doc_id(@file.id).update_attributes(:moved => true)
      @transaction = @docable.checklist.transaction
      @transaction.doc_accesses.find_or_create_by_doc_id(@file.id)
    end
    render :text => @file.id
  end
  
  def flip
    @doc = Doc.find(params[:id])
    #Pdftkw.flip(File.join(Rails.root, "public", @doc.file.url))
    Pdftkw.pdf_action_s3(@doc, "D")
    redirect_to :back
  end
  
  def left
    @doc = Doc.find(params[:id])
    Pdftkw.pdf_action_s3(@doc, "L")
    redirect_to :back
  end
  
  def right
    @doc = Doc.find(params[:id])
    Pdftkw.pdf_action_s3(@doc, "R")
    redirect_to :back
  end
  
  def move
    @docable.doc_accesses.moved.destroy_all

    params[:file_ids].each do |id|
      @doc_access = @docable.doc_accesses.find_or_create_by_doc_id(id)
      @doc_access.update_attributes(:moved => true)
    end if params[:file_ids]
    
    @transaction = @docable.checklist.transaction
  end
  
  def reload
    @doc = Doc.find(params[:id])
    @transaction = @doc.transaction
    render :action => "move"
  end
  
  def update
    @doc = Doc.find(params[:id])
    
    
    if @doc.update_attributes(params[:doc])
      redirect_to :back, notice: 'File was successfully renamed.'
    else
      redirect_to :back, alert: 'Error with file renaming.'
    end
    
  end
  
  def review
    @doc = Doc.find(params[:id])
    checked = !@doc.review?
    @doc.update_attributes( :review => checked )
    
    RecentActivity.create(:transaction_id => params[:transaction_id], 
                          :user_id => current_user.id, 
                          :message =>  "#{checked ? 'Reviewed' : 'Unreviewed'} file #{@doc.filename}")
                          
     @transaction = Transaction.find(params[:transaction_id])
  end
  
  def move_to_checklist_items
    @doc = Doc.find(params[:id])
    @doc.doc_accesses.only_ci.destroy_all
    
    params[:file_ids].each do |id|
      @checklist_item = ChecklistItem.find(id)
      
      @doc_access = @checklist_item.doc_accesses.find_or_create_by_doc_id(params[:id])
      @doc_access.update_attributes(:moved => true)
      
    end unless params[:file_ids].blank?
    @transaction = Transaction.find(params[:transaction_id])
  end
  
  def overwrite
    @doc = Doc.find(params[:id])
    @old_doc = @docable.docs.where(:file => @doc.filename).first
    @old_doc.doc_accesses.each do |da|
      @doc.doc_accesses.find_or_create_by_docable_id_and_docable_type(da.docable_id, da.docable_type)
    end
    @doc.update_attributes(:user_ids => @old_doc.users.map(&:id))
    @old_doc.destroy if @old_doc
    redirect_to :back
  end
  
  def assign_users
    @doc = Doc.find(params[:id])
    params[:file_ids] << @doc.user.id
    @doc.update_attributes(:user_ids => params[:file_ids], :users_assigned => true)
    @transaction = Transaction.find(params[:transaction_id])
  end
  
  def assign_libs
    @doc = Doc.find(params[:id])
    
    params[:file_ids].each do |id|
      DocAccess.where(:doc_id => @doc.id).destroy_all
      @library = Library.find(id)
      @library.doc_accesses.find_or_create_by_doc_id(params[:id])
    end
  end
  
  def destroy
    @doc = Doc.find(params[:id])
    @transaction = Transaction.find(params[:transaction_id])
    RecentActivity.create(:transaction_id => params[:transaction_id], 
                          :user_id =>  current_user.id, 
                          :message =>  "deleted file #{@doc.filename}")
    @doc.destroy
    
  end
  
  def upload_process
    
  end
  
  def show_pdf
    @doc = Doc.find(params[:id])
    @key = 1+Random.rand(21890242423423432190823212)
    @doc.update_attributes(:secret_key => @key.to_s)
  end
  
  def get_secret_key
    @doc = Doc.find(params[:id])
    key = 1+Random.rand(21890242423423432190823212)
    @doc.update_attributes(:secret_key => key.to_s)
    render :text => key
  end
  
  def show_file
    @doc = Doc.find_by_secret_key(params[:id].to_s)
    data = open(@doc.file.url)
    @doc.update_attributes(:secret_key => nil)
    send_file data, :disposition => 'inline', :type=>"application/pdf", :x_sendfile=>true
  end
  
  def show_png
    @doc = Doc.find_by_secret_key(params[:id].to_s)
    @doc.update_attributes(:secret_key => nil)
    #@doc = Doc.find(params[:id])
    render :layout => false
  end
    
  def download
    @doc = Doc.find(params[:id])

    open(@doc.file.url) {|doc|
      tmpfile = Tempfile.new("tmp_#{@doc.filename}")
      File.open(tmpfile.path, 'wb') do |f| 
        f.write doc.read
      end 
      send_file tmpfile.path, :filename => "#{@doc.filename}"
    }   
  end
  
  def after_upload
    @existing_file = false
    @pdf_only = false
    @incompatible = false
    @doc = Doc.find(params[:id])
    @docable = @doc.doc_accesses.first.docable
    @transaction = (@doc.doc_accesses.last.docable.class.name == 'Transaction' || @doc.doc_accesses.last.docable.class.name == 'Library') ? @doc.doc_accesses.last.docable :  @doc.doc_accesses.last.docable.checklist.transaction
    
    PngWorker.perform_async(@doc.id)
    
    
    if @transaction.docs.map(&:alias).select{|c| c==@doc.alias}.length > 1
      @existing_file = true
      @doc.destroy
    end
    
    if @global_company.transaction_details.first.only_pdf? && !@doc.filename.include?(".pdf")
      @pdf_only = true
      @doc.destroy
    end
    
    if @doc.incompatible?
      @incompatible = true
      @doc.destroy
    end
  end
  
  private
  
 
  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @docable = resource.singularize.classify.constantize.find(id)
  end
    
end
