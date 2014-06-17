class Note < ActiveRecord::Base
  attr_accessor :mail_it, :extra_params
  attr_accessible :checklist_id, :mail_it, :extra_params, :status, :transaction_id, :user_id, :complete_items, :incomplete_items, :by_mail, :for_users
  belongs_to :transaction
  belongs_to :user
  
  has_many :recent_activities, :dependent => :destroy
  after_save :add_recent_activity
  after_create :send_mail
  
  def note_message
		t = ""
    if self.complete_items? || self.incomplete_items?
     	t += "<div class='message-items'>"

      if self.complete_items?
        t += "<h5 class='heading'>Completed checklist items:</h5>"
        t += "<ul>"

        self.transaction.checklist_items.checked_only.each do |item|
          t += "<li>#{item.name}</li>" unless item.name.blank?
        end

        t += "</ul>"
      end
      
      if self.incomplete_items?
        t += "<h5 class='heading'>Incomplete checklist items:</h5>"
        t += "<ul>"

        self.transaction.checklist_items.unchecked_only.each do |item|
          t += "<li>#{item.name}</li>" unless item.name.blank?
        end

        t += "</ul>"
      end

			t += "</div>"

    end
    return t
      
  end
  
  private
  
  def send_mail
    if self.mail_it?
      count = self.extra_params['attachment-count'].to_i
      recent_activity_attachments = ""
      
      count.times do |i|
        recent_activity_attachments += self.transaction.mail_activity(self.extra_params, i)
      end
      
      self.mail_text recent_activity_attachments
    end
  end
  
  def mail_text recent_activity_attachments
    mail_text = MailText.create(:content => self.status)
    message = mail_text.create_iframe(self.user, self.extra_params['subject'], recent_activity_attachments)
    self.transaction.mail_recent_activity( self.user, message )
  end
  
  def add_recent_activity
    RecentActivity.create(:transaction_id => self.transaction.id, 
                          :user_id =>  self.user_id, 
                          :message =>  "added note <i>#{self.status}</i> #{note_message}",
                          :note_id => self.id) unless self.by_mail?
  end
end
