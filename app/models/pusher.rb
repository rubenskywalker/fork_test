class Pusher
  require 'eventmachine'
  require 'faye'
  
  def self.push chanel, options = {}
    
    EM.run do
      client = Faye::Client.new(configatron.faye)
      publication = client.publish(chanel, options)
      
      publication.callback do
        puts "[PUBLISH SUCCEEDED]"
        EM.stop_event_loop
      end
      publication.errback do |error|
        puts "[PUBLISH FAILED] #{error.inspect}"
        EM.stop_event_loop
      end
        
    end
    
  end
end