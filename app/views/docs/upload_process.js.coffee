'<%- if params[:process_view]=="false" %>'
$('#<%= params[:upload_container] %>').html('<%= escape_javascript(render("progress_bar"))%>')
'<%- else %>'
$('#<%= params[:upload_container] %>').append('<%= escape_javascript(render(params[:process_view]))%>')
'<% end %>'