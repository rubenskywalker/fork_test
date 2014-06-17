class Pdftkw
  def self.flip file
    tmp_file = "/tmp/new_#{Random.rand(1000000)}.pdf"
    system "pdftk #{file} cat 1-endsouth output #{tmp_file} && mv #{tmp_file} #{file}"
  end
  
  def self.left file
    tmp_file = "/tmp/new_#{Random.rand(1000000)}.pdf"
    system "pdftk #{file} cat 1-endeast output #{tmp_file} && mv #{tmp_file} #{file}"
  end
  
  def self.right file
    tmp_file = "/tmp/new_#{Random.rand(1000000)}.pdf"
    system "pdftk #{file} cat 1-endwest output #{tmp_file} && mv #{tmp_file} #{file}"
  end
  
  
  def self.pdf_action_s3 doc, pdf_action
    file_url = doc.file.url
    file_name = doc.filename
    tmp_file = "/tmp/new_#{Random.rand(1000000)}.pdf"
    tmp_url_path = File.join(Rails.root, "public", file_name)
    tmp_update_url = "http://app.piratetesternow.com/#{file_name}"
    system "cd /tmp && wget -O #{file_name} '#{file_url}' && pdftk /tmp/#{file_name} cat 1-end#{pdf_action} output #{tmp_file} && mv #{tmp_file} #{tmp_url_path}"
    if doc.update_attributes(:remote_file_url => tmp_update_url)
      PngWorker.perform_async(doc.id)
    end
    system "rm #{tmp_url_path}"
  end
  
  def self.copy_file_to_local_png doc
    file_name = doc.filename
    tmp_url_path = File.join(Rails.root, "public", "png", file_name)
    
    if Rails.env.eql?('development') 
      system "cp #{File.join(Rails.root, 'public', doc.file.url)} #{tmp_url_path}"
    else
      system "wget -O #{tmp_url_path} '#{doc.file.url}'"
    end
    
  end
  
  def self.create_png_version doc
    doc.png_docs.destroy_all unless doc.png_docs.empty?
    
    Pdftkw.copy_file_to_local_png doc
    file_name = doc.filename
    pages_dir_name = file_name.split(".pdf")[0]
    pages_dir = File.join(Rails.root, "public", "png", pages_dir_name)
    
    tmp_url_path = File.join(Rails.root, "public", "png")
    tmp_file_path = File.join(Rails.root, "public", "png", file_name)
    converter_path = File.join(Rails.root, "bash", "pdfconv.sh")
    
    system "cd #{tmp_url_path} && #{converter_path} ./#{file_name}"
    
    Dir.glob("#{pages_dir}/*.png") do |png|
     png_doc = doc.png_docs.create()
     png_doc.file = File.open(png)
     png_doc.save!
     
    end
    
    system "rm -r #{pages_dir} && rm #{tmp_file_path}"
    
  end
  
  
  
end