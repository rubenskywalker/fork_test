$('#transaction_contacts').html('<%= escape_javascript(render("mini_contact", :transaction => @transaction, :show_trash => 0))%>')
$('#documents').html('<%= escape_javascript(render("transactions/all_docs")) %>')
$('#contact_counter').html('Contacts involved (<%=@transaction.attach_contacts.length%>)')
$('.outside_agents_well').hide()
$(".outside_agents").click ->
  $(".outside_agents_well").toggle()
Hlp.Load.toggle_contacts()
Hlp.Load.clear_contacts_form()
Hlp.Load.create_multi_select()
Hlp.Load.assign_files_to()
Hlp.Load.close_assign_files()

Hlp.Load.growl_alert("Contact successfully created", "success")
$("[rel='tooltip']").tooltip()
$('#transaction_notes_well').html('<%= escape_javascript(render("notes/form")) %>')
$('#recent_activities').html('<%= escape_javascript(render("transactions/recent_activities")) %>')
'<%- if @existing_user == true %>'
Hlp.Load.confirm_existing_user('<%= @contact.id %>', '<%= current_user.id %>', '<%= @attach_contact.id %>')
'<% end %>'
