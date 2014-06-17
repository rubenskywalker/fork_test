$('.add_an_note_well').hide()
$('#recent_activities').html('<%= escape_javascript(render("transactions/recent_activities")) %>')