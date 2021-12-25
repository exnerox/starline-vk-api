
st(message)
{
	id=177023107 ; ваш вкид
	sleep 50	; просто так
		random,rnd,1,999999	; для апи вк, чтоб не банил запрос
		groupid:="ид группы без минуса"	; ид вашей группы
		token:="тут токен" ; токен вашей группы
		w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
		url:="api.vk.com/method/messages.send?user_id=" id "&random_id=" rnd "&peer_id=" groupid "&message=" message "&access_token=" token "&v=5.103"
		;proxy:="vk-api-proxy.xtrafrancyz.net/_/method/messages.send?" ; нашел прокси для вк апи запросов если вдруг кому-то нужно, если что проверено лично на другом скрипте в массовой продаже, работает стабильно, но ответ бывает от сразу до 5сек
		;url:=proxy
		w.Open("GET", "https://" url) ; открываем соединения
		try w.Send() ; отправляем сообщение
		w.Send()

	sleep 50
}
return
;тоже самое как и выше, но можно отправить на любой вкид. это функции с другого скрипта, и остальные тоже. Не стираю, может кому-то пригодятся
vk(id,message)
{
	sleep 50
	global vkru ;делал для другого скрипта, нужен был прокси или нет.
	;	vkid=177023107
	;	message=loh1
		random,rnd,1,999999
		groupid:="ид группы без минуса"	; ид вашей группы
		token:="тут токен" ; токен вашей группы
		w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
		proxy:="vk-api-proxy.xtrafrancyz.net/_/"
		url:="api.vk.com/method/messages.send?user_id=" id "&random_id=" rnd "&peer_id=" groupid "&message=" message "&access_token=" token "&v=5.103"
		if (vkru=1)
			w.Open("GET", "https://" url)
		else
			w.Open("GET", "https://" proxy "" url)
		try w.Send()
		w.Send()

	sleep 50
}
return
;отправка сообщения на вкид с клавиатурой
vkb(id,message,keyboard)
{
	sleep 50
	global vk
	global vkru
		if vk=0
			return
	keyboard = 
(LTrim join
%keyboard%
)
	;msgbox, % keyboard
	random,rnd,1,999999
		groupid:="ид группы без минуса"	; ид вашей группы
		token:="тут токен" ; токен вашей группы
	w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	;w.SetRequestHeader("Content-Type", "application/json")
	proxy:="vk-api-proxy.xtrafrancyz.net/_/"
	url:="api.vk.com/method/messages.send?user_id=" id "&random_id=" rnd "&peer_id=" groupid "&message=" message "&access_token=" token "&v=5.103&keyboard=" keyboard ""
	if (vkru=1)
		w.Open("GET", "https://" url)
	else
		w.Open("GET", "https://" proxy "" url)
	try
		w.Send()
	w.Send()
	;msgbox, % url
	;run, https://%url%

}
return








/*
{
		groupid:="ид группы без минуса"	; ид вашей группы
		token:="тут токен" ; токен вашей группы
	id=177023107
	random,rnd,1,999999
	message=loh
	run, https://api.vk.com/method/messages.send?user_id=177023107&random_id=2&peer_id=вырезал&message=&access_token=вырезал2&v=5.103, hide
}
return
*/