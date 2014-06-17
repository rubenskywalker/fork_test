$('#item_<%= dom_id(@checklist) %>').html('<%= escape_javascript(render("checklists/items_list", :checklist_items => @checklist.checklist_items))%>')
$('#documents').html('<%= escape_javascript(render("transactions/all_docs")) %>')

Hlp.Load.create_multi_select()
Hlp.Load.assign_files_to()
Hlp.Load.check_checklist_item()
$('.new_checklist_input').val('')
$('.new_checklist_input_button').attr("disabled", "false")
$(".on_the_spot_editing").each initializeOnTheSpot


Hlp.Load.uploader_init_with_id('#upload_<%= dom_id(@checklist_item)%>')
Htp.Auto.checklist_item_create()
