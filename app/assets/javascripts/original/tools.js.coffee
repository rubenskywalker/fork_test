window.Tools = {}
	
@Tools.Utils =
  uploader: (path, button, upload_container, process_view, after_view, pdf_only)->
    
    uploader = new plupload.Uploader
      runtimes: 'html5,flash,html4'
      browse_button: button
      max_file_size: '50mb'
      url: path
      drop_element: "drop_#{button}"
      flash_swf_url: '/assets/plupload.flash.swf'
      file_data_name: 'file'
      multipart: true
      multipart_params:
        'authenticity_token': $('meta[name=csrf-token]').attr('content')
      filters: if pdf_only then [{title : "Pdf files", extensions : "pdf"}] else []
      
    
    uploader.init()
      
    uploader.bind 'FilesAdded', (up, files) =>
      _(files).each (file) =>
        $.get "/docs/#{file.id}/upload_process?upload_container=#{upload_container}&process_view=#{process_view}"
      up.start()

    uploader.bind 'FileUploaded', (up, file, response) =>
      setTimeout (->
        $.get "/docs/#{response.response}/after_upload?file_id=#{file.id}&after_view=#{after_view}&upload_container=#{upload_container}"
      ), 2000
      
#      $('#images_for_'+button).append(response.response)
#      Base.Initializers.theSpotEditor()
#      Base.Initializers.piroBox()
    
    uploader.bind 'UploadFile', (up, file) =>
      @setState(file)
 
    uploader.bind 'UploadProgress', (up, file) =>
      @setState(file)

  

  setState: (file) ->
    $('#'+file.id+' > .progress-bar').css(width: "#{file.percent}%")
    $('#'+file.id+' > .progress-bar').html("#{file.name}(#{file.size}) - #{file.percent}%")
