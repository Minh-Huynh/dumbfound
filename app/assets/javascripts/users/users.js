var ready;
ready = function() {
				$("#user_phone_number").mask("(999)999-9999", {placeholder: "(xxx)xxx-xxxx"});
};

$(document).on('turbolinks:load ready', ready);

