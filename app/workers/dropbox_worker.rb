class DropboxWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :dropbox, :retry => false
  
  def perform w
    DropboxSync.sync_all
  end
end