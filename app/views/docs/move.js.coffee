'<%- @transaction.checklist_items.each do |checklist_item| %>'
$('#drop_upload_<%= dom_id(checklist_item)%>').html('<%= escape_javascript(render("checklist_items/checklist_item", :checklist_item => checklist_item))%>') 
'<% end %>'
Hlp.Load.create_multi_select()
Hlp.Load.assign_files_to()
$(".open").removeClass("open")
$('#recent_activities').html('<%= escape_javascript(render("transactions/recent_activities")) %>')
$('#documents').html('<%= escape_javascript(render("transactions/all_docs")) %>')
$('.assigned_checklists').tooltip()

$("[rel='tooltip']").tooltip()
Hlp.Load.show_doc_embed_file()