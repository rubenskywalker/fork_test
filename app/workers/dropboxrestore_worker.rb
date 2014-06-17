class DropboxrestoreWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :dropbox, :retry => false
  
  def perform su
    user = User.find(su)
    DropboxSync.restore_for_user(user)
  end
end