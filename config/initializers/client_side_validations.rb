# ClientSideValidations Initializer

# Uncomment the following block if you want each input field to have the validation messages attached.
# ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
#   unless html_tag =~ /^<label/
#     %{<div class="field_with_errors">#{html_tag}<label for="#{instance.send(:tag_id)}" class="message">#{instance.error_message.first}</label></div>}.html_safe
#   else
#     %{<div class="field_with_errors">#{html_tag}</div>}.html_safe
#   end
# end

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
     %{<div class="field_with_errors">#{html_tag}</div><div class="flash_notice hidden_item" data-type="error">#{instance.method_name} - #{instance.error_message.first}</div>}.html_safe
 end