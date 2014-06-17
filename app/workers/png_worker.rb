class PngWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :dropbox, :retry => false
  
  def perform doc_id
    doc = Doc.find(doc_id)
    Pdftkw.create_png_version(doc)
    Pusher.push("/update/png", {'url' => "/docs/#{doc_id}/reload".to_json})
  end
end