class NotesController < ApplicationController
  before_filter :find_note, :except => [:index, :new, :create]
  def index
    @notes = Note.all
  end
 
  def new
    @note = Note.new
  end

  def create
    @transaction = Transaction.find(params[:transaction_id])
    @note = @transaction.notes.create(params[:note].merge!(for_users: params[:contacts_ids].join(",")))
    
    params[:contacts_ids].each do |id|
      
      DefaultMailer.send_note(User.find(id), @note, params[:docs_ids]).deliver
    end if params[:contacts_ids]
  end

  def update
    if @note.update_attributes(params[:note])
      redirect_to @note, notice: 'Note was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @note.destroy
    redirect_to notes_url 
  end
  
  private
  def find_note
    @note = Note.find(params[:id])
  end
end
