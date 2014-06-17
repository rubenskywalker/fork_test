$('#dinamyc_content').html('<%= escape_javascript(render(:partial => "form"))%>')
$('form[data-validate]').validate()


Tools.Utils.switch_selected_default_button('')
Tools.Initializers.user_questions()
$('#photos_filter').hide()