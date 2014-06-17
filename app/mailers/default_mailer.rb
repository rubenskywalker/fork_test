class DefaultMailer < ActionMailer::Base
  default from: "postmaster@piratetesternow.com"
  
  def welcome(user, email=nil)
      @user = user
      #@parent = User.find(user.parent_id)
      #mail(:to => @user.email, :subject => "#{@parent.first_name} #{@parent.last_name} invited you to #{@parent.company} transaction management!") if @parent
      mail(:to => email.nil? ? @user.email : email, :subject => @user.welcome_subject)
  end
  
  
  def send_note(user, note, docs = [])
    @user = user
    @note = note
    @transaction = note.transaction
    @parent = note.user
    docs.each do |doc_id|
      file = Doc.find(doc_id)
      if Rails.env.eql?('development')
        attachments[file.filename] = File.read(File.join(Rails.root, "public", file.file.url))
      else
        system "cd /tmp && wget -O #{file.filename} '#{file.file.url}'"
        attachments[file.filename] = File.read("/tmp/#{file.filename}")
      end
    end
    mail(:from => @transaction.user_mail_attachment(user), :to => @user.email, :subject => "New note added to #{@transaction.tname}")
    
  end
  
  def send_pass(user, pass)
    @user = user
    @pass = pass
    mail(:to => @user.email, :subject => "Welcome to app.piratetesternow.com")
  end
  
  def invitation_mail(user, invite, email=nil)
    @from_user = user
    @invite = invite
    @user = invite.user
    mail(:to => email.nil? ? @user.email : email, :subject => "#{@from_user.fullname} of #{@from_user.company.name} has invited you to be added to his account at piratetesternow.com")
  end
  
  def transaction_closing_soon(transaction, email=nil)
    @user = transaction.user
    @transaction = transaction
     mail(:to => email.nil? ? @user.email : email, :subject => "Transaction will closing soon")
  end
  
  def transaction_expired(transaction)
    @user = transaction.user
    @transaction = transaction
     mail(:to => @user.email, :subject => "Some of your transactions are expired now")
  end
  
end
