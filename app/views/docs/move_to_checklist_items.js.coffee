<% broadcast "/messages/action" do %>
'<%- @transaction.checklist_items.each do |checklist_item| %>'
$('#drop_upload_<%= dom_id(checklist_item)%>').html('<%= escape_javascript(render("checklist_items/checklist_item", :checklist_item => checklist_item))%>') 
'<% end %>'


$(".open").removeClass("open")
$('#documents').html('<%= escape_javascript(render("transactions/documents")) %>')
$('.assigned_checklists').tooltip()
Hlp.Load.show_doc_embed_file()

Hlp.Load.create_multi_select()
Hlp.Load.assign_files_to()
<% end %>