class MailText < ActiveRecord::Base
  attr_accessible :content
  
  def create_iframe user, subject, recent_activity_attachments
    iframe = self.content.length > 1000 ? "<iframe width='100%' height='500px' frameborder=0 src='/mail_texts/#{self.id}'></iframe>" : Sanitize.clean(self.content, Sanitize::Config::RESTRICTED)
    subject_id = 1+Random.rand(21890232190823212)
    message = " sent an email titled <a href='#', class='open_subject', data-subject='#{subject_id}'>#{subject}</a> to this transaction"
    message += "<div id='subject-message-#{subject_id}' class='hidden_item'></br><b>From: </b>#{user.fullname} <a href='mailto:#{sender}'>#{sender}</a></br><b>Subject: </b>#{subject}</br><b>Received: </b>#{Time.now.strftime("%A, %m-%d-%Y at %I:%M%p")}</br>#{iframe}</br></br>Attachments:</br>#{recent_activity_attachments.blank? ? 'None' : recent_activity_attachments}</br></div>"
  end
end
