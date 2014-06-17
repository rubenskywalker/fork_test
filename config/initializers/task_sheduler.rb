require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.cron '1 0 * * *' do
  TransactionStatus.where(:category => "Listing").each do |ts|
    ts.transactions.where("expiration_date < ?", Time.now).each do |t|
      status = nil
      status = ts.transaction_detail.transaction_statuses.where(:category => "Expired").first
      t.update_attributes(:transaction_status_id => status.id)
      
      DefaultMailer.transaction_expired(t).deliver
    end
  end
  Transaction.where("close_sate < ?", (Time.now - 3.days)).each do |t|
    DefaultMailer.transaction_closing_soon(t).deliver
  end
  
end

scheduler.cron '55 0 * * *' do
  #DropboxWorker.perform_async(0)
end