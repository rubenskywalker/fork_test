$(".open").removeClass("open")
$('#transaction_contacts').html('<%= escape_javascript(render("transactions/mini_contact")) %>')

$("[rel='tooltip']").tooltip()
Hlp.Load.create_multi_select()
Hlp.Load.assign_files_to()
