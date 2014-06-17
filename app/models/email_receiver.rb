class EmailReceiver < Incoming::Strategies::Mailgun
  setup :api_key => 'key-18lz4bygdw-j9yqkizcuelk2-ehydfq7'

  def receive(mail)
    puts mail#%(Got message from #{mail.to.first} with subject "#{mail.subject}")
  end
  
 
end

