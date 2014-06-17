$(".users_<%= dom_id(@doc) %>").find(".assigned_users").remove()
$(".users_<%= dom_id(@doc) %>").html('<%= escape_javascript(render("docs/assign_users_process", :doc => @doc)) %>')
$(".open").removeClass("open")
$("[rel='tooltip']").tooltip()
Hlp.Load.create_multi_select()
Hlp.Load.assign_files_to()
Hlp.Load.close_assign_files()


