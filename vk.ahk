
manage:
{
		text0 =  
		payload0 =  
		text1 =  
		payload1 = 
		;������� ����������, �� �����, �� ����� ����� ���. �� ������� ������� �������, ��� �������� ����������
			
			;�������� ������ ��� �������, ��� �������� ������
			;https://api.vk.com/method/messages.getHistory?start_message_idoffset=0&start_message_id=-1&count=1&extended=0&peer_id=177023107&group_id=�������&v=5.122&access_token=
			ComObjError(false)
			whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")  
			whr.SetTimeouts(2000, 2000, 5000, 5000) ; ������������� ����-���� ����������
			token:="�������" ; ��� ��� ����� �� �������� ������ ����������
			grp:=������� ; ��� �� ������ ( ��� ������ )
			user:=177023107 ; ��� �� ��������� ��, ���� ������������ ���������
			whr.Open("GET", "https://api.vk.com/method/messages.getHistory?count=1&user_id=" user "&group_id=" grp "&v=5.122&access_token=" token , true) ; ��������� ����������
			whr.Send() ; ���������� ������
			try whr.WaitForResponse(10) ; ���� �����(������ �������� ����� ��, �� �� ������ ������ ��� �������������� �������� � ������. ������� ���� ����-��� 10���
			jsontext := % whr.ResponseText  ; JSON����� �� ��
			JSON = 
			(LTrim Join 
				%jsontext% 
			)
			;��������� ����� �� ��
			;msgbox % jsontext
			htmldoc := ComObjCreate("htmlfile") 
			Script := htmldoc.Script 
			Script.execScript(" ", "JScript") 
			;JSON - ���� ������ ������, ����� ������ ����� �������� JSON ����� �� ��
				/*
					{
						"response": {
							"count": 70907,
							"items": [
								{
									"date": 1617513038,
									"from_id": 124124124,
									"id": 4798496,
									"out": 0,
									"peer_id": 2000000140,
									"text": "������ ����� ������ ����� �������� � ��� �������",
									"conversation_message_id": 75862,
									"fwd_messages": [],
									"important": false,
									"random_id": 0,
									"attachments": [],
									"is_hidden": false
								}
							]
						}
					}
				*/
				/*
				{
					"response": {
						"count": 71053,
						"items": [
							{
							"date": 1617641329,
							"from_id": 177023107,
							"id": 4806891,
							"out": 1,
							"peer_id": 2000000140,
							"text": "[�������|������� �� �����.]\n�� ���� �� [id0|������������]:\n 1 �� 2 ������",
							"conversation_message_id": 76053,
							"fwd_messages": [],
							"important": false,
							"random_id": 371230,
							"attachments": [],
							"is_hidden": false,
							"reply_message": {
								"date": 1617641198,
								"from_id": �������,
								"text": "[�������|@companychecker] ��, ����.",
								"attachments": [],
								"conversation_message_id": 76049,
								"peer_id": 2000000140,
								"id": 4806881,
								"payload": "{\"message_new\":\"spam177023107spam19.46.05\"}"
							}
						}
					]
				}
				}
				*/
			;
			oJSON := Script.eval("(" . JSON . ")") 
			;������� ��������� JSON ����� �� �� � ������ ahk, ����� �����
			;random := % oJSON.response.items.0.random_id ; ����������� � ������ �������, �� ����� ����-�� ����� ����� ��� ����?
			vkid := % oJSON.response.items.0.from_id	; ����� ��������� ����, ����� ��������� ��������� ������ �� ���
			text0 := % oJSON.response.items.0.text 		; �����, ������� �� �����������
			time := % oJSON.response.items.0.date		; timestamp(�� ������������ ����, � � 1970� �����������)
			payload0 := % oJSON.response.items.0.payload	; �������� �������� � ������ ������������� ������ � ������ ����������
			;msgbox, % payload
			if RegExMatch(payload0,"^{""message_new""\:""(.*)""}$",pl)
				payload0:=pl1
			;�������� �������� ������ ������� ��� ������������� 
			;msgbox, vkid - %vkid% ... text0 - %text0% ... payload - %payload0%
			;msgbox, % payload
			; text0
			;
				if RegExMatch(time,"^([0-9]{4,4})([0-9]{2,2})([0-9]{2,2})([0-9]{2,2})([0-9]{2,2})([0-9]{2,2})$",ti)
				{
					Y:=ti1
					M:=ti2
					D:=ti3
					H:=ti4
					H+=3
					Mi:=ti5
					S:=ti6
				}
				date=%D%%M%%Y%
				;������ ����������� �����, �� ����� � ���� ������� ����� � ����� �� �����������
			if (vkid!=user) ; �� ���� ������ ���������? ���� �� �� ���, �������� ��������� ���������� ��������
				return
			;������ �����, ������� �� ���������, ��� ������ �������� ������ ���. �� ������ ������ ��� ��� ������, ���� ��������� ������ �������������� 
			if RegExMatch(text0,"^��������.*$") ; �������� ����������� ����������� � �������
			{
				notclear() ; ������� ������������ ��� �������
				st("�������") ; ����� ���� � ��
			}
			
			;msgbox, vkid - %vkid% ... text0 - %text0% ... payload - %payload0%
			
			

			
}
return



;��� �������� � ������� ����� �������, �� ��� ����� ���������� ��� � ��������� ���� ������������ ���������� ��� �������� ���������� � �������� �� �����, ����� ����-�� ����������
settings:
{
	b1:=button("��������� �������","!�����1",2)
	b2:=button("��������� ������������","!�����1",3)
	
	b=%b1%,%b2%
/*
(LTrim join
%b1%,%b2%
)
*/
	settings:=keys(b,1)
				vkb(vkid,"������ ����������� ������ ���������������? :)",settings)
}
return

; ��������� ������� kolvoprod sklone skltwo kolvo1-14k price400-520 one-twosklone-seven skltwoon skltwooff skloneon skloneoff changesklad sklonels-sf-lv skltwols-sf-lv prodone-sevenon-off changeprod skl1








/*
	buttona(ns,text,payload,color := "secondary")
	button(text,payload,color := "secondary")
	������:
	������ ������ �� ������ �������
	b1:=button("���������","!�����1",2) ; ����� ��������� � �������� �������� !�����, ���� primary
	b2:=buttons(1,"������","!help",2)	; ������ ������ �� ������ �������. ������� ns ����������� 1! ��������� ���� ����� ��� ������
	;���� ����� ��� ������ �� �������, �� ns ����������� 2!!
	b3:=buttons(3,"������","!help",2)	; �������� ������ �� ������ �������. ������� ns ����������� 3! ��������� ���� ����� ��� ������

	��� �� ���������� ��� ����������� ������������� ������, ������� ������ ��� ���:(������ ����� ����� ���� ������� ��������� ��� json)
	b:= b1 "," b2 "," b3

	������������ ������� ����������
	;b-��� ������, 0 ��� 1 ��� ������(������ ��������� ��� �����) ���������� ���������
	;���, ������ "keyboard" ����� ���������� � ���, � ���������� ����������
	keyboard:=keys(b,0)
	
	��� �������� � ����������� ������� ��������� ������� vkb(vkid,"�����",keyboard)
*/
/*
	ns - �� 1 �� 3. ��� ���� ������ ��������� ����� ��������.
	������ ������ ������ ������ ���� ns 1. ���� ����� ��� ������, ����������� ns 3. 
	���� ������ ������ ��� ���. ������ ns 1, ��������� ns 2, ����� ��������� ns 3!
	text - ����� �� ������
	payload �������� ��������
	color ����������� �� 1 �� 4, ����.
*/
buttona(ns,text,payload,color := "secondary")
{
	;primary - blue
	;secondary  - white
	;negative - red
	;positive - green
	if color=1
		color:="secondary"
	else if color=2
		color:="primary"
	else if color=3
		color:="positive"
	else if color=4
		color:="negative"
	else
		color:="secondary"
	if ns=1
	{
		ks =
		(LTrim join
			[
				{
					"action":{
						"type":"text",
						"label":"%text%",
						"payload":{"message_new":"%payload%"}
					},
				"color":"%color%"
				}
		)
	}
	else if ns=2
	{
		ks =
		(LTrim join
			
				{
					"action":{
						"type":"text",
						"label":"%text%",
						"payload":{"message_new":"%payload%"}
					},
				"color":"%color%"
				}
		)
	}
	else if ns=3
	{
		ks =
		(LTrim join
			
				{
					"action":{
						"type":"text",
						"label":"%text%",
						"payload":{"message_new":"%payload%"}
					},
				"color":"%color%"
				}
			]
		)
	}
	return ks
}
return

/*
���� ������
*/
button(text,payload,color := "secondary")
{
	;primary - blue
	;secondary  - white
	;negative - red
	;positive - green
	if color=1
		color:="secondary"
	else if color=2
		color:="primary"
	else if color=3
		color:="positive"
	else if color=4
		color:="negative"
	else
		color:="secondary"
	ks = 
	(LTrim join
		[
			{
				"action": {
				"type":"text",
				"label":"%text%",
				"payload":{"message_new":"%payload%"}
				},
				"color":"%color%"
			}
		]
	)
	;msgbox, % ks
	return ks
}
return





;����� �������� ������, ��������� �� � ����������, INLINE ��� �� ������.
keys(buttons,line)
{
	if line=1
	{
		kss = 
		(LTrim join
			{
			  "one_time": false,
			  "buttons": [
					%buttons%
				],
			  "inline": true
			}
		)
	}
	else if line=0
	{
		kss = 
		(LTrim join
			{
			  "one_time": false,
			  "buttons": [
					%buttons%
				],
			  "inline": false
			}
		)
	}
	;msgbox, % kss
	return kss
}
return







