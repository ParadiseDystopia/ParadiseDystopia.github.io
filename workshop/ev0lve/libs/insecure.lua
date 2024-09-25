local database_info = database.load('definitely_not_sus_dont_open_me_please');

if not database_info then
	database_info = {
		["count"] = 0
	}
	database.save('definitely_not_sus_dont_open_me_please', database_info);
end


if not info.ev0lve.allow_insecure then
	if database_info.count > 10000 then
		gui.show_message('require_insecure_message', 'I lied', "But you cheated by changing the json file, shame on you.")
	elseif database_info.count > 500 then
		gui.show_message('require_insecure_message', 'Hey', "Can you stop??? The message will not change anymore from now on.")
	elseif database_info.count > 100 then
		gui.show_message('require_insecure_message', 'Okay', "This won't do you any good.")
	elseif database_info.count > 5 then
		gui.show_message('require_insecure_message', 'BRo', "Turn oN ALLoW inSecure PLease.")
	elseif database_info.count > 0 then
gui.show_message('require_insecure_message', 'ATTENTION! Activate "Allow Insecure" Feature for Script Functionality.', "Dear "..info.ev0lve.username..[[
,

We have noticed that the "Allow Insecure" feature has not been activated for your script functionality, despite our previous request to do so. We understand that it may be challenging to navigate system settings, but we kindly ask that you take another look at the message we sent and follow the instructions provided to activate this feature.

If you continue to experience difficulties locating the "Allow Insecure" feature, we encourage you to reach out to our support team for further assistance. Our team is always ready to help and will be happy to guide you through the process of activating this feature.

We remind you that the "Allow Insecure" feature may have potential security implications, and it is important to exercise caution when utilizing this feature. We trust that you will take the necessary precautions to ensure the security of your system.

Thank you for your attention to this matter, and we look forward to your prompt response.

Best regards,
Agapornis
		]])
	else
	gui.show_message('require_insecure_message', 'ATTENTION! Activate "Allow Insecure" Feature for Script Functionality.', "Dear "..info.ev0lve.username..[[
,

We hope this message finds you well. We regret to inform you that we have detected an issue with the script you have initiated, which requires the activation of the "Allow insecure" feature. We understand that this may be concerning for you, but we kindly request that you turn on this feature promptly to ensure the smooth functioning of the script.

To locate the "Allow insecure" feature, we suggest utilizing the search function, which is conveniently located in the top right corner of the menu. This will enable you to swiftly access and activate the feature, thus resolving any issues you may be experiencing.

However, we would like to remind you that enabling the "Allow insecure" feature may have potential security implications. We strongly advise that you exercise caution while utilizing this feature, as it may compromise the security of your system.

We understand that security is of utmost importance, and therefore we encourage you to take all necessary precautions to protect your system. This includes avoiding clicking on any suspicious scripts or opening any attachments from unknown sources.

In conclusion, we would like to thank you for your cooperation and understanding in this matter. If you require any further assistance, please do not hesitate to reach out to our support team, who will be more than happy to assist you.

Best regards,
Agapornis
		]])
	end
	database_info.count = database_info.count + 1
	database.save('definitely_not_sus_dont_open_me_please', database_info);
elseif database_info.count > 0 then
	gui.show_dialog('insecure_turned_on_message', 'CONGRATULATIONS on Activating the "Allow Insecure" Feature!', "Dear "..info.ev0lve.username..[[
,

We are pleased to inform you that the "Allow Insecure" feature has been successfully activated for your script functionality. We appreciate your prompt attention to this matter and your willingness to take the necessary steps to ensure the smooth functioning of your script.

We would like to take this opportunity to congratulate you on your ability to locate and activate the "Allow Insecure" feature. It is clear that you are well-versed in navigating system settings and have a great understanding of the various features and functionalities available.

We recognize that some users may find it challenging to locate the "Allow Insecure" toggle, but you have proven to be quite adept at doing so. This is a testament to your intelligence and resourcefulness, and we are grateful to have such a knowledgeable user on our platform. Click "No" so that this message won't pop up again.

As we previously mentioned, we do advise caution when utilizing the "Allow Insecure" feature, as it may have potential security implications. However, we trust that you will take all necessary precautions to ensure the security of your system while utilizing this feature.

In conclusion, we would like to thank you for your cooperation and commend you on a job well done. If you require any further assistance, please do not hesitate to reach out to our support team, who will be more than happy to assist you.


Best regards,
Agapornis
		]], gui.dialog_buttons_yes_no, function (res)
    if res == gui.dialog_result_affirmative then
        gui.show_message('insecure_nice_try', ':(', 'Why did you not read the message? this dialogue will appear again I promise you.');
    else
        gui.show_message('insecure_ok', ':)', 'Thanks! Have fun with the script!');
        database_info.count = 0
		database.save('definitely_not_sus_dont_open_me_please', database_info);
    end
end)
end