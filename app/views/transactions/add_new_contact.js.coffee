$('#transaction_form').prepend('<%= escape_javascript(render("attach_contacts_fields_tmpl", :user_id => @contact.id, :role_id => @role_id, :data_regexp => 1+Random.rand(21890232190823212)))%>')
$('#contact_items').append('<%= escape_javascript(render("contacts/contact_item", :contact => @attach_contact))%>')
$('.outside_agents_well').hide()
Hlp.Load.create_multi_select()
Hlp.Load.assign_files_to()
Hlp.Load.close_assign_files()
Hlp.Load.delete_contact_item()
$("[rel='tooltip']").tooltip()