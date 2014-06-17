require 'dropbox_sdk'

class DropboxSyncNew
  attr_accessor :access_token

  APP_KEY = '74rrjl2hhk6qcoz'
  APP_SECRET = '18bm4w0k5sf46mw'
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def self.auth_link
    flow = DropboxOAuth2FlowNoRedirect.new(DropboxSync::APP_KEY, DropboxSync::APP_SECRET)
    authorize_url = flow.start()
  end
  
  def self.finish code
    flow = DropboxOAuth2FlowNoRedirect.new(DropboxSync::APP_KEY, DropboxSync::APP_SECRET)
    access_token, user_id = flow.finish(code) rescue nil
    unless access_token.nil?
      dbox_client = DropboxSync.new(:access_token => access_token)
      dbox_client.client.file_create_folder("Upload/") rescue nil
      dbox_client.client.file_create_folder("Backup/") rescue nil
    end
    access_token
  end
  
  def self.backup_path transaction
    status_category = transaction.transaction_status.nil? ? "Nostatus" : transaction.transaction_status.category
    "Backup/#{transaction.location.name}/#{status_category}/#{transaction.id}-#{transaction.tname.strip}/"
  end
  
  def self.upload_path transaction
    status_category = transaction.transaction_status.nil? ? "Nostatus" : transaction.transaction_status.category
    "Upload/#{transaction.location.name}/#{status_category}/#{transaction.id}-#{transaction.tname.strip}/"
  end
  
  def self.tmp_dir u
    dir = File.join(Rails.root, "dropbox", u.id.to_s)
    system "mkdir #{dir}" rescue nil
    dir
  end
    
  
  def client
    DropboxClient.new(self.access_token)
  end
  
  def save_local_copy u, cursor = nil
    delta = cursor.nil? ? self.client.delta : self.client.delta(cursor)
    delta['entries'].each do |e|
      system "mkdir '#{DropboxSync.tmp_dir(u)}#{e[1]["path"]}'" if e[1]["is_dir"]
      
      #puts "'#{DropboxSync.tmp_dir(u)}#{e[1]["path"]}'" if e[1]["is_dir"]
      
      self.upload_file(e[1]["path"], u) unless e[1]["is_dir"]
    end
  end
  
  def update_files_and_folders u
    
    path = DropboxSync.tmp_dir(u)
    transactions = Transaction.where("transactions.user_id IN (?) OR attach_contacts.user_id = ?", u.default_ids, u.id).includes(:attach_contacts)
    transactions.each do |transaction|
      system "mkdir #{DropboxSync.tmp_dir(u)}/#{DropboxSync.backup_path(transaction)}"
      
      
      transaction.docs.each do |doc|
        file = Rails.env.eql?('development') ? open(File.join(Rails.root, "public", doc.file.url)) : open(doc.file.url)
        filename = doc.filename
        dir_path = DropboxSync.backup_path(transaction)
        path = "#{DropboxSync.tmp_dir(u)}/#{dir_path}#{filename}"
        system "cp #{file} #{path}"
      end
      
      
    end
  end
  
  def upload_updated u
    self.client.file_create_folder("#{DropboxSync.tmp_dir(u)}/Backup")
  end
  
  def upload_file path, u
    contents, metadata = self.client.get_file_and_metadata(path)
    
    tmp_url_path = DropboxSync.tmp_dir(u)
    
    open(tmp_url_path, 'w') {|f| f.puts contents.to_s.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'}) } 
  end
  
  def get_current_coursor
    self.client.delta['cursor']
  end
  
  def update_coursor u
    u.update_attributes(:dropbox_cursor => dbox_client.get_current_coursor)
  end
  
  def self.sync_for_user u
      dbox_client = DropboxSync.new(:access_token => u.dropbox_code)
      
      
      
      dbox_client.save_local_copy(u, u.dropbox_cursor)
      dbox_client.update_files_and_folders(u)
      dbox_client.upload_updated(u)
      dbox_client.update_coursor(u)
      
      
      
  end
  
  def account_info
    self.client.account_info()
  end
  
  
  def self.get_member
  end

end