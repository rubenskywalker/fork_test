class PngDoc < ActiveRecord::Base
  attr_accessible :doc_id, :file
  
  belongs_to :doc
  
  mount_uploader :file, PngDocUploader
end
