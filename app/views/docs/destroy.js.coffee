$('.delete_<%= dom_id(@doc)%>').remove()
'<%- @transaction.checklist_items.each do |checklist_item| %>'
$('#drop_upload_<%= dom_id(checklist_item)%>').html('<%= escape_javascript(render("checklist_items/checklist_item", :checklist_item => checklist_item))%>') 
'<% end %>'

