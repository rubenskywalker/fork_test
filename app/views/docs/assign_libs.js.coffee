$('#current_<%=dom_id(@doc)%>').remove()
'<%- params[:file_ids].each do |id| %>'
$('#library_doc_library_<%=id%>').append('<%= escape_javascript(render("library_doc", :doc => @doc))%>')
$('#links_library_<%=id%>').html('<%= escape_javascript(render("libraries/links", :library => Library.find(id)))%>')
'<% end %>'

Hlp.Load.docs_inside()
Hlp.Load.show_doc_embed_file()
Hlp.Load.create_multi_select()
Hlp.Load.assign_files_to()

$(".open").removeClass("open")