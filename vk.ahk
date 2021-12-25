
manage:
{
		text0 =  
		payload0 =  
		text1 =  
		payload1 = 
		;Обнулим переменные, хз азчем, но пусть лучше так. На примере другого скрипта, так работало стабильней
			
			;сохранил просто для примера, как выглядит запрос
			;https://api.vk.com/method/messages.getHistory?start_message_idoffset=0&start_message_id=-1&count=1&extended=0&peer_id=177023107&group_id=вырезал&v=5.122&access_token=
			ComObjError(false)
			whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")  
			whr.SetTimeouts(2000, 2000, 5000, 5000) ; устанавливаем тайм-ауты соединения
			token:="вырезал" ; ваш апи токен из настроек вашего сообщества
			grp:=вырезал ; ваш ид группы ( без минуса )
			user:=177023107 ; ваш ид странички вк, куда отправляются сообщения
			whr.Open("GET", "https://api.vk.com/method/messages.getHistory?count=1&user_id=" user "&group_id=" grp "&v=5.122&access_token=" token , true) ; открываем соединения
			whr.Send() ; отправляем запрос
			try whr.WaitForResponse(10) ; ждем ответ(обычно приходит сразу же, но вк бывает виснит или индивидуальные проблемы с инетом. поэтому ждем тайм-аут 10сек
			jsontext := % whr.ResponseText  ; JSONответ от ВК
			JSON = 
			(LTrim Join 
				%jsontext% 
			)
			;Укоротили ответ от ВК
			;msgbox % jsontext
			htmldoc := ComObjCreate("htmlfile") 
			Script := htmldoc.Script 
			Script.execScript(" ", "JScript") 
			;JSON - ниже просто пример, чтобы видеть какой приходит JSON ответ от ВК
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
									"text": "Майдан перед мостом шкода работают в обе стороны",
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
							"text": "[вырезал|Спасибо за голос.]\nЗа спам от [id0|пользователя]:\n 1 из 2 подряд",
							"conversation_message_id": 76053,
							"fwd_messages": [],
							"important": false,
							"random_id": 371230,
							"attachments": [],
							"is_hidden": false,
							"reply_message": {
								"date": 1617641198,
								"from_id": вырезал,
								"text": "[вырезал|@companychecker] Да, спам.",
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
			;сделали текстовый JSON ответ от ВК в массив ahk, можем юзать
			;random := % oJSON.response.items.0.random_id ; использовал в другом скрипте, но может кому-то нужно будет под себя?
			vkid := % oJSON.response.items.0.from_id	; будем проверять вкид, чтобы сообщения принимать только от вас
			text0 := % oJSON.response.items.0.text 		; текст, который вы отправляете
			time := % oJSON.response.items.0.date		; timestamp(не человеческая дата, а с 1970г посекундная)
			payload0 := % oJSON.response.items.0.payload	; полезная нагрузка в случае использования ответа с кнопок клавиатуры
			;msgbox, % payload
			if RegExMatch(payload0,"^{""message_new""\:""(.*)""}$",pl)
				payload0:=pl1
			;полезную нагрузку делаем удобней для использования 
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
				;делаем читабельное время, но вроде в этом скрипте нигде я время не использовал
			if (vkid!=user) ; от кого пришло сообщение? если не от нас, ретурном прерываем дальнейшие действия
				return
			;читаем текст, который мы отправили, для своего удобства сделал так. Вы можете делать как вам удобно, хоть полностью писать словосочетания 
			if RegExMatch(text0,"^Прервать.*$") ; прервать циклическое уведомление о тревоге
			{
				notclear() ; очищаем своеобразный кэш тревоги
				st("Успешно") ; пишем себе в вк
			}
			
			;msgbox, vkid - %vkid% ... text0 - %text0% ... payload - %payload0%
			
			

			
}
return



;это фрагмент с другого моего скрипта, но тут можно посмотреть как я использую свою своеобразную библиотеку для создания клавиатуры и отправки ее ботом, может кому-то пригодится
settings:
{
	b1:=button("Настройки скрипта","!настр1",2)
	b2:=button("Настройки безопасности","!безоп1",3)
	
	b=%b1%,%b2%
/*
(LTrim join
%b1%,%b2%
)
*/
	settings:=keys(b,1)
				vkb(vkid,"Какими настройками хочешь воспользоваться? :)",settings)
}
return

; Настройка Скрипта kolvoprod sklone skltwo kolvo1-14k price400-520 one-twosklone-seven skltwoon skltwooff skloneon skloneoff changesklad sklonels-sf-lv skltwols-sf-lv prodone-sevenon-off changeprod skl1








/*
	buttona(ns,text,payload,color := "secondary")
	button(text,payload,color := "secondary")
	пример:
	делаем кнопку на первой строчке
	b1:=button("Настройки","!настр1",2) ; текст Настройка и полезная нагрузка !настр, цвет primary
	b2:=buttons(1,"Помощь","!help",2)	; первая кнопка на первой строчке. Поэтому ns обязательно 1! Остальное тоже самое как сверху
	;если будут еще кнопки на строчке, то ns обязательно 2!!
	b3:=buttons(3,"Помощь","!help",2)	; посленяя кнопка на первой строчке. Поэтому ns обязательно 3! Остальное тоже самое как сверху

	еще не придумывал как реализовать воссоединение кнопок, поэтмоу делаем это так:(просто нужно между ними запятую поставить для json)
	b:= b1 "," b2 "," b3

	окончательно создаем клавиатуру
	;b-это кнопки, 0 или 1 это инлайн(внутри сообщения или снизи) клавиатура создастся
	;Все, теперь "keyboard" можно отправлять в апи, и клавиатура применится
	keyboard:=keys(b,0)
	
	Для отправки с клавиатурой сделана отдельная функция vkb(vkid,"текст",keyboard)
*/
/*
	ns - от 1 до 3. Это если делаем несколько строк кнопочек.
	первая кнопка всегда должна быть ns 1. Если всего две кнопки, обязательно ns 3. 
	если кнопок больше чем две. Первая ns 1, остальные ns 2, самая последняя ns 3!
	text - текст на кнопке
	payload полезная нагрузка
	color опционально от 1 до 4, цвет.
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
одна кнопка
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





;после создания кнопок, формируем ее в клавиатуру, INLINE или не инлайн.
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







