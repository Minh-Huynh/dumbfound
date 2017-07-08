var ready;
ready = function() {
				$("#user_phone_number").mask("(999)999-9999", {placeholder: "(xxx)xxx-xxxx"});
};

$(document).ready(ready);
$(document).on('turbolinks:load', ready);

