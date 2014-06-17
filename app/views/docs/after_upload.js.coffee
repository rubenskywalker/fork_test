'<%- if @existing_file == true %>'
Hlp.Load.growl_alert "Duplicate file wasn't uploaded.", 'error'
$('#container_<%= params[:file_id]%>').remove()
'<%- elsif @pdf_only == true %>'
Hlp.Load.growl_alert "Non-pdf file wasn't uploaded.", 'error'
$('#container_<%= params[:file_id]%>').remove()
'<%- elsif @incompatible == true %>'
Hlp.Load.growl_alert "Incompatible character(s) used in transaction. Do not use / < > : ” | ? * in your filename.", 'error'
$('#container_<%= params[:file_id]%>').remove()
'<%- else %>'

<% broadcast "/messages/action" do %>
'<%- if params[:after_view]=="checklist_item_upload" %>'
$('#assigned_to_item<%= dom_id(@docable)%>').html('<%= escape_javascript(render("checklist_items/assigned", :checklist_item => @docable))%>') 
'<%- else %>'
$('#container_<%= params[:file_id]%>').replaceWith('<%= escape_javascript(render(params[:after_view], :doc => @doc, :i => 100))%>')
'<%- end %>'
'<%- if @doc.doc_accesses.first.docable.class.name == "ChecklistItem" %>'
$('#documents').append('<%= escape_javascript(render("doc", :doc => @doc, :i => 100))%>')
'<%- end %>'
$("[rel='tooltip']").tooltip()
Hlp.Load.show_doc_embed_file()

'<%- unless @doc.doc_accesses.last.docable.class.name == "Library" %>'
'<%- @transaction.checklist_items.each do |checklist_item| %>'
$('#ul_<%= dom_id(checklist_item)%>').html('<%= escape_javascript(render("checklist_items/files", :checklist_item => checklist_item))%>') 
'<% end %>'
'<%- end %>'

Hlp.Load.create_multi_select()
Hlp.Load.assign_files_to()
Hlp.Load.close_assign_files()
<% end %>

'<%- unless @doc.doc_accesses.last.docable.class.name == "Library" %>'
$('#recent_activities').html('<%= escape_javascript(render("transactions/recent_activities")) %>')
'<%- end %>'

'<%- end %>'

