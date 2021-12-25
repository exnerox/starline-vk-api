#NoEnv
#Persistent
#SingleInstance FORCE
#MaxThreads
#UseHook
#NoEnv
#SingleInstance, force
SetControlDelay, -1
;SetKeyDelay, -1, -1
SetBatchLines, -1
global n := "<br>"
;st("bot started")
global appId := "1234 у меня было 4 цифры" ; appid из раздела разработчика my.starline.ru , но сначала нужно получить доступ к нему через почту старлайна
global secret := "код, у меня начинался на x-abcdabcdabcd" 	; тоже с ЛК ст му.старла.ру секретный код! никому нельзя его говорить))
global st_getCode := "https://id.starline.ru/apiV3/application/getCode?" 	;ага
global st_getToken := "https://id.starline.ru/apiV3/application/getToken?"	;угу
global st_webauth := "https://developer.starline.ru/json/v2/auth.slid"		;думаю понятно
global deviceid := 862623253232420 если че девайсид изменил на рандомные цыферки, но количество сохранил оригиналом											;deviceid полученный из getdeviceid(), чтобы не получать вечно его ид функцией
global code																	;хз зачем я это все повводил, когда все только начинал писать, оно мне сейчас уже не нужно, НО ПУСТЬ ОТ ГРЕХА ПОДАЛЬШЕ ОСТАНЕТСЯ, хехехе)
global md5_code																;ес че и про это я тоже
global token																;и про это
global md5_token															;ага
global st_login := "https://id.starline.ru/apiV3/user/login"				;угу
global last=0																;и это тоже вроде, хз короче
global notification:=[]														;а это уже нужное, тут короче будет храниться ид тревоги, сколько непрочитанных сообщений во время тревоги и сами тексты тревоги
notification["alarm"]:=0
notification["unread"]:=0
;установим их в нули


;бля, я не помню зачем это делал, но что-то хотел сделать
SetTimer, Alarm, 5000
SetTimer, Alarm, off
;SetTimer, chek, 2000
;SetTimer, chek, on
;тут тоже че то хоетл с таймерами поделать, я уже хуй его

;ну, тут запустим основной цикл
Loop
{
	Loop 1
	{
		gosub info						;
		if (notification["alarm"]>0)	;если есть пропущенная тревога
		{
			gosub Alarm					;отправляем в вк сообщения о пропущенной тревоге,если таковая имеется
			sleep 2222					;дабы не словить бан от вк апи, сделаем кд
		}
	}
}
return

;
Alarm:
{
	;обнулим переменные
	message:=""
	messages:=""
	global notification		; хуй его, но без глобала не захотела работать, хотя ей глобал тут не нужен, ватафэк, ну хуй его. работает и пусть будет.
	Alarm:=notification.alarm	;получаем состояние тревоги- 0 тревоги нет, 1-внимание(предупредительный и тд), 2-тревога, двери, сильный удар и тд
	;msgbox, Alarm a: %Alarm%
	if alarm=0
		return
	unread:=notification.unread	;скольконепрочитанных событий
	;msgbox, Alarm unread: %unread%
	if (unread>1)
	{
		Loop % unread	;собираем все непрочитанные события в одну переменную
		{
			if A_Index=1
				message:=notification[A_Index]
			else
			{
				messages:=notification[A_Index]
				message:=message "<br><br>" messages
			}
		}
		st("[ALARM " unread "]<br>"message)		;указываем сколько событий непрочитанно в тревоге, и отправляем все тревожные и нетревожные события.
		;НЕ тревожные события отправляются вместе с тревожными, т.к. эти события зафлуживаются тревожными. Потому оно будет собираться вместе с ними.
		;msgbox
	}
	else
		st("[ALARM]"notification[1])
}
return

not(id)
{
	global notification
	text:=notification[id]
	;"Тревога! " n "" desc "" n "Время: " time
	;msgbox, text: %text%
	return text
}
return

notadd(text, al)
{
	global notification
	tr:=notification.alarm
	if (tr>al)
		notification.alarm
	else if (tr<al)
		notification.alarm:=al
	else if (tr=al)
		notification.alarm:=tr
	else
		notification.alarm:=1
	unread:=notification.unread
	;msgbox, unread0 %unread%
	unread+=1
	;msgbox, unread1 %unread%
	notification[unread]:=text
	;msgbox, % notification.unread
	notification.unread := unread
	;msgbox, unread2 %unread%
	;msgbox, unread %text%
	;msgbox, al %al%
	;msgbox, tr %tr%
}
return
;auth()
;webauth()
;msgbox, % getcode()
;msgbox, % getToken()
;msgbox, % auth()
;getdeviceid()
;webauth()
;msgbox, % getdeviceid()
;goto setarm
!2::
command("arm_start")
return
!3::
command("arm_stop")
return
!4::
msgbox, % notification[alarm]
msgbox, % notification[unread]
return
!5::
allevents()
return
/*
	manage:
	{
		random,rand, 1000, 10000
		sleep % rand
		gosub info
	}
	return
*/

info:
{
	gosub, manage ;читаем диалог ВК на предмет непрочитанных сообщений (нажатых кнопок)
	;command:="data"
	global deviceid		;ну понятно, ид устройства 
	global slnet		;тоже понятно, без этого никуда, это типо такого токена у старлайна
	admin:="https://developer.starline.ru/json/v3/device/" deviceid "/data"		;ну,ссылку переменной сделал для удобства
	w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	w.SetTimeouts(3000, 3000, 7000, 7000)	;тайм-ауты
	w.Open("GET", admin, true)				;открываем соединения
	;w.setRequestHeader("token", token)		;не помню зачем оно тут, но уже было закоменченно
	slnet:=webauth()						;получаем slnet, но,зачем? если он уже получен и в глобале? ладно. хер с ним. потом разберусь. Работает и Пока пусть будет так
	w.setRequestHeader("Cookie", "slnet=" slnet)	;отправляем куки токена 
	w.Send(data)									;отправляем , зачем data? можно же просто запрос.. нууууууу, ладно, работает и хуй с ним, потом гляну. может просто так скопировал, а может так и нужно
	w.WaitForResponse()								;ждем ответа
	;msgbox, % w.ResponseText()
	jsontext := % w.ResponseText 					;далее json ответ преобразуем для ахк
	;msgbox, getdvid: %jsontext%
	JSON = 
		(LTrim Join 
			%jsontext% 
		)		
	;msgbox, info: %JSON%
	htmldoc := ComObjCreate("htmlfile") 
	Script := htmldoc.Script 
	Script.execScript(" ", "JScript")
	oJSON := Script.eval("(" . JSON . ")")
	
	;ну и смотрим все что нам нужно, и в переменные хуярим
	;если что, сразу после этого info:{} идет полный json ответ, мб кому-то пригодится, чтоб не измучивать себя 
	
	event_type := % oJSON.data.event.type
	event_time := % oJSON.data.event.timestamp
	event_time := u2a(event_time)	;unix time>человеко подобное, но в цифры в ряд.
	;думаю тут все понятно
	if RegExMatch(event_time, "(\d+)(\d)(\d)$",s)
		sec:=s2 s3
	if RegExMatch(s1, "(\d+)(\d)(\d)$", m)
		min:=m2 m3
	if RegExMatch(m1, "(\d+)(\d)(\d)$", h)
		hour:=h2 h3
	hour+=3 ; UTC+3
	if hour=24
		hour=00
	else if hour>24
		hour-=24
	else hour:=hour
	;делаем человеко читаемое время
	time:=hour ":" min ":" sec
	;сделали. присвоили TIME.
	;msgbox, type: %event_type%
	;msgbox, ts: %event_time%
	;msgbox, time: %time%
	;20211222225021
	;20211222225021
	; сверху  сохранял пример циферок в ряд(годмесяцденьчасминутасекунда)
	;получаем расшифровку последнего события устройства
	;потому как есть только номер события(event_type)
	events(event_type, desc, group_id)
	;делаем проверку времени последнего события с авто
	if (last=event_time)
	{
		;msgbox, last: %last% `ncurrent: %event_time%
		sleep 1500
		return
	}
	;если событие не старое, то не прерываем действия ниже
	;устанавливаем новое время последнего события
	global last
	last	:= event_time
	
	/*
		в event(событиях) у старлайна есть несколько групп.
		Как я понял, 1 и 4 это события,
		5 это что-то уже забыл, крч не важная херня
		2 и 3 - события тревоги
		2- важные
		3- не важные, но все равно их сделал как важными 
	*/
	if (group_id=1) or if (group_id=4) or if (group_id=5)
	{
		txt:= desc "" n "Время: " time
		st(desc "" n "Время: " time)
		if notification.alarm>0
			notadd(txt,0)
	}
	else if (group_id=2)
	{
		txt:="Тревога! " n "" desc "" n "Время: " time
		txtt:=desc "" n "Время: " time
		notadd(txtt, 2)
		st(txt)
		st(txt)
		st(txt)
	}
	else if (group_id=3)
	{
		txt:="Внимание! " n "" desc "" n "Время: " time
		notadd(txt, 1)
		st(txt)
	}
	else 
	{
		txt:="" desc "" n "Время: " time
		notadd(txt, 1)
		st(txt)
		if notification.alarm>0
			notadd(txt,0)
	}
		;notadd()- добавить непрочитанное событие в тревожное циклическое уведомление
		;НЕ тревожные события отправляются вместе с тревожными, т.к. эти события зафлуживаются тревожными. Потому оно будет собираться вместе с ними.
		
	;msgbox group_id: %group_id%
	;msgbox desc: %desc%
	;msgbox event_type: %event_type%
	

	;msgbox, %event_time%
	;тут для примера весь JSON ответ от старлайна
		/*
			{
			  "codestring": "OK",
			  "data": {
				"state": {
				  "neutral": false,
				  "webasto_timer": 0,
				  "ign": false,
				  "hijack": false,
				  "add_sens_bpass": false,
				  "valet": false,
				  "run": false,
				  "hood": false,
				  "alarm": false,
				  "shock_bpass": false,
				  "arm_moving_pb": false,
				  "door": false,
				  "out": false,
				  "pbrake": true,
				  "r_start_timer": 0,
				  "hfree": true,
				  "hbrake": false,
				  "trunk": false,
				  "arm": true,
				  "r_start": false,
				  "ts": 1640212808,
				  "tilt_bpass": false,
				  "webasto": false,
				  "arm_auth_wait": false
				},
				"functions": [
				  "eng_sensor",
				  "shock_cfg",
				  "xml_cfg",
				  "gsm_control",
				  "rstart_cfg",
				  "ble",
				  "scoring",
				  "int_sensor",
				  "offless_hijack",
				  "gsm",
				  "info",
				  "position",
				  "state",
				  "tracking",
				  "push",
				  "events",
				  "adv_state",
				  "mon_cfg",
				  "tracking",
				  "events",
				  "controls",
				  "adv_controls",
				  "adv_guard",
				  "rstart_cfg",
				  "shock_cfg",
				  "ble2"
				],
				"firmware_version": "2.26.0",
				"telephone": "+79вырезал",
				"r_start": {
				  "wakeup_ts": 1,
				  "period": {
					"has": false
				  },
				  "battery": {
					"has": true
				  },
				  "cron": {
					"has": false
				  },
				  "temp": {
					"has": false
				  }
				},
				"type": 3,
				"obd": {
				  "ts": 1640197270,
				  "mileage": 132827,
				  "fuel_litres": null,
				  "fuel_percent": 69
				},
				"event": {
				  "type": 1090,
				  "timestamp": 1640208959
				},
				"ua_url": "",
				"position": {
				  "sat_qty": 0,
				  "ts": 1640211174,
				  "r": 150,
				  "s": 0,
				  "x": вырезал,
				  "is_move": true,
				  "dir": 0,
				  "y": вырезал
				},
				"activity_ts": 1640212808,
				"common": {
				  "reg_date": вырезал,хз че там,
				  "ts": 1640212808,
				  "etemp": null,
				  "ctemp": 8,
				  "gps_lvl": 0,
				  "battery": 12.46500015258789,
				  "gsm_lvl": 11,
				  "mayak_temp": 0
				},
				"sn": "вырезал серийник",
				"status": 1,
				"alias": "Имя авто",
				"device_id": вырезал девайс ид, как он выглядит пример оставил сверху в глобале,
				"typename": "Охранный комплекс",
				"balance": [
				  {
					"ts": 1640193151,
					"operator": "",
					"value": 27,
					"currency": "",
					"key": "active",
					"state": 2
				  }
				],
				"alarm_state": {
				  "add_l": false,
				  "run": false,
				  "trunk": false,
				  "hbrake": false,
				  "hijack": false,
				  "shock_h": false,
				  "tilt": false,
				  "hood": false,
				  "shock_l": false,
				  "add_h": false,
				  "door": false,
				  "ts": 1640212808,
				  "pbrake": false
				}
			  },
			  "code": 200
			}

		*/
	
}
return
;setarm:
;{
command(command)
{
	global deviceid
	global slnet
	;ну тут понятно уже.. токен и ид
	;пока что сделал эти доступные команды
	;arm(start\stop) - охрана вкл\выкл
	;ign(start\stop) - автозапуск завести,заглушить
	;arm ign arm_start arm_stop ign_start ign_stop 
	if not RegExMatch(command, "^(arm|arm_start|arm_stop|ign|ign_start|ign_stop)$")
		msgbox error command %command%
	else 
	{
		data := "{""type"": """ command """, """ command """: 1}"
		admin := "https://developer.starline.ru/json/v1/device/" deviceid "/set_param"
		w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
		w.SetTimeouts(3000, 3000, 7000, 7000)
		w.Open("POST", admin, true)
		;w.setRequestHeader("token", token)
		w.setRequestHeader("Cookie", "slnet=" slnet)
		w.Send(data)
		w.WaitForResponse()
		;msgbox, % w.ResponseText()
		jsontext := % w.ResponseText 
		;msgbox, arm: %jsontext%
		JSON = 
			(LTrim Join 
				%jsontext% 
			)		
		;msgbox, % JSON
		htmldoc := ComObjCreate("htmlfile") 
		Script := htmldoc.Script 
		Script.execScript(" ", "JScript")
		oJSON := Script.eval("(" . JSON . ")") 	
		;msgbox, arm %jsontext%
	}
}
return 
	;ответ который приходит от старлайна, пока не придумал что с этим делать, но сохранил.
	Скорей всего
		/*
			{
			  "add_sens_bpass": "0",
			  "alarm": "0",
			  "arm": "1",
			  "code": 200,
			  "codestring": "OK",
			  "disarm_trunk": "0",
			  "door": "0",
			  "dvr": "0",
			  "dvr_channel": "0",
			  "getbalance": "0",
			  "hbrake": "0",
			  "hfree": "1",
			  "hijack": "0",
			  "hood": "0",
			  "ign": "0",
			  "neutral": "0",
			  "out": "1",
			  "panic": "0",
			  "pbrake": "0",
			  "poke": "0",
			  "r_start": "0",
			  "reply_code": 0,
			  "run": "0",
			  "shock_bpass": "0",
			  "tilt_bpass": "0",
			  "trunk": "0",
			  "type": "command_reply",
			  "valet": "0",
			  "webasto": "0"
			}
		*/


!1::
Reload
Return
 ;ниже это все для работы с токенами, интернетом и тд. Я это не создавал, пиздил с инета. Поэтому комментить ничего не могу. Авторов,если они были указаны в скриптах, оставлял.
 MD5(string, case := False)    ; by SKAN | rewritten by jNizM
{
    static MD5_DIGEST_LENGTH := 16
    hModule := DllCall("LoadLibrary", "Str", "advapi32.dll", "Ptr")
    , VarSetCapacity(MD5_CTX, 104, 0), DllCall("advapi32\MD5Init", "Ptr", &MD5_CTX)
    , DllCall("advapi32\MD5Update", "Ptr", &MD5_CTX, "AStr", string, "UInt", StrLen(string))
    , DllCall("advapi32\MD5Final", "Ptr", &MD5_CTX)
    loop % MD5_DIGEST_LENGTH
        o .= Format("{:02" (case ? "X" : "x") "}", NumGet(MD5_CTX, 87 + A_Index, "UChar"))
    return o, DllCall("FreeLibrary", "Ptr", hModule)
} ;https://autohotkey.com/boards/viewtopic.php?f=6&t=21


#include Crypt.ahk
#include CreateFormData.ahk
#include BinArr.ahk
#include HTTPRequest.ahk
Class Multipart
{
	Make(ByRef PostData, ByRef PostHeader, Array_FormData*) {
		static CRLF := "`r`n"
		static DW   := "UInt"
		static ptr  := (A_PtrSize = "") ? DW : "Ptr"

		PostData := ""
		Boundary := this.RandomBoundary()

		For Index, FormData in Array_FormData
		{
			If (  pos := InStr(FormData, "=")  )
				FormData_Name    := SubStr(FormData, 1, pos-1)
			  , FormData_Content := SubStr(FormData, pos+1)
			Else
				FormData_Name    := FormData

			If (  SubStr(FormData_Content, 1, 1) = "@"  )  {
				FilePath := SubStr(FormData_Content, 2)

				FileRead, binData, %FilePath%
				FileGetSize, binSize, %FilePath%
				SplitPath, FilePath, FileName

				VarSetCapacity( placeholder, binSize, 32 )
				PostData .= "------------------------------" Boundary CRLF
				            . "Content-Disposition: form-data; name=""" FormData_Name """; filename=""" FileName """" CRLF
                            . "Content-Type: " this.MimeType(binData) CRLF CRLF
                offset   := StrLen( PostData )
                PostData .= placeholder CRLF
			}
			Else
			{
				If (  SubStr(FormData_Content, 1, 1) = "<"  )
					FileRead, FormData_Content, % SubStr(FormData_Content, 2)

				PostData .= "------------------------------" Boundary CRLF
				            . "Content-Disposition: form-data; name=""" FormData_Name """" CRLF CRLF
				            . FormData_Content CRLF
			}
		}

		PostData .= "------------------------------" Boundary "--" CRLF
		If offset
			DllCall( "RtlMoveMemory", Ptr, &PostData + offset, Ptr, &binData, DW, binSize )

		PostHeader := "Content-Type: multipart/form-data; boundary=----------------------------" Boundary

		Return Boundary
	}

	MimeType(ByRef binData) {
		static HeaderList := ["424D"     , "4749463"  , "FFD8FFE"   , "89504E4"  , "4657530"                      , "49492A0"   ]
		static TypeList   := ["image/bmp", "image/gif", "image/jpeg", "image/png", "application/x-shockwave-flash", "image/tiff"]

		this.toHex(binData, hex, 4)

		For Index, Header in HeaderList
			If RegExMatch(hex, "^" Header)
				Return TypeList[ Index ]

		Return "application/octet-stream"
	}

	toHex( ByRef V, ByRef H, dataSz=0 )  { ; http://goo.gl/b2Az0W (by SKAN)
		P := ( &V-1 ), VarSetCapacity( H,(dataSz*2) ), Hex := "123456789ABCDEF0"
		Loop, % dataSz ? dataSz : VarSetCapacity( V )
			H  .=  SubStr(Hex, (*++P >> 4), 1) . SubStr(Hex, (*P & 15), 1)
	}

	RandomBoundary() {
		static CharList := "0|1|2|3|4|5|6|7|8|9|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z"
		Sort, CharList, D| Random
		StringReplace, Boundary, CharList, |,, All
		Return SubStr(Boundary, 1, 12)
	}
}
return

;время unix в читабельное.
u2a(vNum:="", vFormat:="yyyyMMddHHmmss")
{
	if !(vNum = "")
		vDate := DateAdd(1970, vNum, "Seconds")
	if (vNum = "") || !(vFormat == "yyyyMMddHHmmss")
		return FormatTime(vDate, vFormat)
	return vDate
}

DateAdd(DateTime, Time, TimeUnits)
{
    EnvAdd DateTime, %Time%, %TimeUnits%
    return DateTime
}
DateDiff(DateTime1, DateTime2, TimeUnits)
{
    EnvSub DateTime1, %DateTime2%, %TimeUnits%
    return DateTime1
}
FormatTime(YYYYMMDDHH24MISS:="", Format:="")
{
    local OutputVar
    FormatTime OutputVar, %YYYYMMDDHH24MISS%, %Format%
    return OutputVar
}

;все возможные эвенты одним json. сохранено в events.txt чтобы 24\7 не делать запрос на старлайн по евенту
allevents()
{
	desc:=""
	groupid:=""
	;https://developer.starline.ru/json/v3/library/events/307
	events:="https://developer.starline.ru/json/v3/library/events"
	ComObjError(false)
	w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	w.SetTimeouts(3000, 3000, 7000, 7000)
	w.Open("GET", events)
	w.SetRequestHeader("Content-Type", "application/json")
	w.Send()
	w.WaitForResponse()
	;msgbox, % w.ResponseText()
	jsontext := % w.ResponseText 
	JSON = 
		(LTrim Join 
			%jsontext% 
		)		
	;msgbox, alleve: %JSON%
	htmldoc := ComObjCreate("htmlfile") 
	Script := htmldoc.Script 
	Script.execScript(" ", "JScript")
	oJSON := Script.eval("(" . JSON . ")")
	code := % oJSON.eventDescriptions.0.code
	desc := % oJSON.eventDescriptions.0.desc
	groupid := % oJSON.eventDescriptions.0.group_id
	;msgbox, eve: %desc%
}
return
;сначала думал делать каждый раз запрос об евенте на старлайн, но подумал ну его нах.
;все возможные эвенты одним json. сохранено в events.txt чтобы 24\7 не делать запрос на старлайн по евенту
events(id, byRef desc, byRef group_id)
{
	/*
		desc:=""
		groupid:=""
		;https://developer.starline.ru/json/v3/library/events/307
		events:="https://developer.starline.ru/json/v3/library/events/" id
		ComObjError(false)
		w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
		w.SetTimeouts(3000, 3000, 7000, 7000)
		w.Open("GET", events)
		w.SetRequestHeader("Content-Type", "application/json")
		w.Send()
		w.WaitForResponse()
		;msgbox, % w.ResponseText()
		jsontext := % w.ResponseText 
		JSON = 
			(LTrim Join 
				%jsontext% 
			)		
		;msgbox, dv: %JSON%
		htmldoc := ComObjCreate("htmlfile") 
		Script := htmldoc.Script 
		Script.execScript(" ", "JScript")
		oJSON := Script.eval("(" . JSON . ")")
		code := % oJSON.eventDescriptions.0.code
		desc := % oJSON.eventDescriptions.0.desc
		groupid := % oJSON.eventDescriptions.0.group_id
		;msgbox, des: %desc%
	*/
	/*
		FileRead, jsontext, events.txt
		;msgbox, dess: %JSONTEXT%
		JSON = 
			(LTrim Join 
				%jsontext% 
			)		
		;msgbox, dv: %JSON%
		htmldoc := ComObjCreate("htmlfile") 
		Script := htmldoc.Script 
		Script.execScript(" ", "JScript")
		oJSON := Script.eval("(" . JSON . ")")
		id-=201
		;JS:= % oJSON[0, "desc"]
		oJS:= % oJSON.300.desc
		msgbox, % oJS
		;msgbox, % JS
		msgbox, dess: %desc%
	*/
	;возможные наработки сохранил, мб кому пригодится. Не стал использовать из-за проблем с кодировкой, которуб было лень решать. Поэтому решил сохранить в .тхт
	FileRead, text, events.txt
	if RegExMatch(text, ".*""code"":" id ",""desc"":""([^""]*)"",""group_id"":(\d)}.*",tt)
	{
		desc:=tt1
		group_id:=tt2
	;msgbox, %desc%
	;msgbox, %groupid%
	}
	;думаю тут понятно, ищем нужный ид евента, и сохраняем его описание и группу(например: ид 1090, Охрана включена, Группа 4,т.е. события)
	
	;msgbox, %desc%
	;msgbox, %groupid%
}
return

;получения кода по аппид и секрету.
;Самое первое возможное действие с апи ст 
getcode()
{
	global code
	global appid
	global st_getCode
	global code
	global md5_code
	ComObjError(false)
	w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	w.SetTimeouts(3000, 3000, 7000, 7000)
	; secret := Crypt.Hash.StrHash(secret,1,"",1)
	md5_secret := md5(secret)
	;msgbox, md5_secret=%md5_secret%
	w.Open("GET", st_getCode "appId=" appId "&secret=" md5_secret)
	try w.Send()
	w.WaitForResponse(15)
	jsontext := % w.ResponseText 
	JSON = 
		(LTrim Join 
			%jsontext% 
		)		
	htmldoc := ComObjCreate("htmlfile") 
	Script := htmldoc.Script 
	Script.execScript(" ", "JScript")
	oJSON := Script.eval("(" . JSON . ")") 	
	code := % oJSON.desc.code
	;msgbox, code %code%
	return code
	;goto gettoken
}
return
;получения токена по коду, второе и единственно возможное действие ст апи, 
gettoken()
{
	global code
	global md5_code
	global token
	global appid
	global st_getToken
	code := getCode()
	ComObjError(false)
	w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	w.SetTimeouts(3000, 3000, 7000, 7000)
	; secret := Crypt.Hash.StrHash(secret,1,"",1)
	;для получения токена, нужно секрет из ЛК ст добавить в единую строку с полученным кодом.
	;Если что, секрет и код не в мд5, а в оригинале. И только после их воссоединения делаем из них мд5 и отправляем
	md5_secret := md5(secret "" code)
	;msgbox, secret=%secret%
	
	w.Open("GET", st_getToken "appId=" appId "&secret=" md5_secret)
	try w.Send()
	w.WaitForResponse(15)
	jsontext := % w.ResponseText 
	JSON = 
		(LTrim Join 
			%jsontext% 
		)		
	htmldoc := ComObjCreate("htmlfile") 
	Script := htmldoc.Script 
	Script.execScript(" ", "JScript")
	oJSON := Script.eval("(" . JSON . ")") 	
	token := % oJSON.desc.token
	;msgbox, token`n %token%`noJSON`n %JSON%
	return token
	
}
return
;Авторизация для получения user_token
;опять же, с этим хуй что сделаешь, но идем дальше, чтобы получить окончательный токен, которым можно что-то делать(slnet)
auth()
{    
	;ничего не могу прокомменить особо, долго ебался с multipart запросом, что только не пытался сделать
	;работает и не трогаю. даже закоменченное и что не используется не удаляю
	
	token:=gettoken()
	;.setRequestHeader("Content-Type",rHeader)
	objParam := { "login": "e@mail"
           , "pass": "SHA1 вашего пароля"}
	CreateFormData(postData, postHeader, objParam)
	ComObjError(false)
	w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	w.SetTimeouts(3000, 3000, 7000, 7000)
	;msgbox, data %data%
	;msgbox, head %Header%
	login:="login=e@mail&pass=SHA1 пароля"
	w.Open("POST", st_login, true)
	w.setRequestHeader("token", token)
		;w.setRequestHeader("CONTENT_TYPE", "multipart/form-data; boundary=------------------t3l7jbr")
	w.SetRequestHeader("Content-Type", postHeader)
	w.SetRequestHeader("Referer", st_login)
	w.Option(6) := False 
	w.Send(postData)
	w.WaitForResponse()
	;msgbox, % w.ResponseStatus
	;msgbox, % w.ResponseText
		;CreateFormData(PostData,Header, objParam)
		;W.SetRequestHeader("Cookie", "login=email; pass=sha1pass")
		;w.SetRequestHeader("Content-Disposition", "form-data; login=email; pass=sha1password")
		;w.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
		;Multipart.Make(PostData, PostHeader, "login=email", "pass=sha1password")
		;w.SetRequestHeader("Content-Type", PostHeader)
		;w.Send(PostData)
		;w.WaitForResponse(15)
	jsontext := % w.ResponseText 
	JSON = 
		(LTrim Join 
			%jsontext% 
		)		
	;msgbox, % JSON
	htmldoc := ComObjCreate("htmlfile") 
	Script := htmldoc.Script 
	Script.execScript(" ", "JScript")
	oJSON := Script.eval("(" . JSON . ")") 	
	usertoken := % oJSON.desc.user_token
	;HttpRequest(st_login, PostData, PostHeader, "Method: POST")
	;msgbox, datap %PostData%
	;msgbox, headp %PostHeader%
	global user_token := usertoken
	;msgbox, % user_token
	AllHeaders := % w.GetAllResponseHeaders()
;	;msgbox, All0: %AllHeaders%
	return user_token
	/*
	Ответ:
	{
	
	  "state": 1,
	  "desc": {
      "id": "вырезал",
      "login": "вырезал@gmail.com",
      "state": "ACTIVE",
      "first_name": "Даня",
      "last_name": "",
      "middle_name": "",
      "company_name": "",
      "sex": "M",
      "lang": "ru",
      "gmt": "+3",
      "avatar": "default",
      "date_register": "не важно",
      "contacts": [
         {
            "id": "вырезал",
            "type": "push",
            "value": "{\"device_name\":\"\",\"app_version\":\"\",\"language\":\"ru\",\"os_type\":\"android2\",\"os_version\":\"\",\"phone_model\":\"\",\"token\":\"вырезал\",\"ser_num\":\"ca7559714f85ed88\"}",
            "confirmed": null,
            "token": " ~вырезал~"
         },
         {
            "id": "вырезал",
            "type": "email",
            "value": "емаил@gmail.com",
            "confirmed": "1",
            "token": " ~вырезал"
         },
         {
            "id": "вырезал",
            "type": "phone",
            "value": "796вырезал",
            "confirmed": "1",
            "token": "вырезал~"
         }
      ],
      "auth_contact_id": null,
      "roles": [
         "user",
         "open-api-user"
      ],
      "subscription": null,
      "user_token": "feвырезал79вырезалcbf4:вырезал",
      "last_auth_date": "",
      "last_auth_ip": "вырезал"
			}
	}
	*/
}
return
;нотификатион клир. короче очистка истории тревог, и аларм=0, чтоб выключить бесконечные уведомления
notclear()
{
	notification.alarm:=0
	notification.unread:=0
}
return
;наконец-то получаем user_id
;и блять, я долго пытался понять, где slnet(токен) которым можно выполнять все команды.
;а он блять в куки был.
;теперь все этапы авторизации пройдены. с md5, sha , кодами токенами, емаееееееееееееееееееее
;нахуй они вообще нужны, я хуй знает. можно было проще все сделать.
;Теперь работаем с этим токеном slnet и им все делаем. все команды и запросы
webauth()
{
	user_token := "вырезал:вырезал"
	;global user_token
	;msgbox, web, token: %user_token%
	data := "{""slid_token"": ""вырезал:вырезал""}"
	ComObjError(false)
	w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	w.SetTimeouts(3000, 3000, 7000, 7000)
	w.Open("POST", st_webauth, true)
	;w.setRequestHeader("token", token)
	w.Send(data)
	w.WaitForResponse()
	AllHeaders := % w.GetAllResponseHeaders()
	;msgbox, All: %AllHeaders%
	;msgbox, % w.ResponseText()
	jsontext := % w.ResponseText 
	;msgbox, webauth: %jsontext%
	/*
	headers:
		Connection: keep-alive
		Date: Wed, 22 Dec 2021 20:33:37 GMT
		Content-Length: 170
		Content-Type: text/json
		Server: nginx
		Set-Cookie: slnet=вырезал; path=/; expires=Thursday, 23-Dec-21 GMT; domain=.starline.ru;
		Content-Security-Policy: upgrade-insecure-requests
		Strict-Transport-Security: max-age=31536000; includeSubDomains; preload

	*/
	if RegExMatch(AllHeaders, ".*slnet=(.*); path.*",net)
		slnt:=net1
	;msgbox slnet=%slnt%
	JSON = 
		(LTrim Join 
			%jsontext% 
		)		
	;msgbox, % JSON
	htmldoc := ComObjCreate("htmlfile") 
	Script := htmldoc.Script 
	Script.execScript(" ", "JScript")
	oJSON := Script.eval("(" . JSON . ")") 	
	
	/*
	ответ:
		{
			"code" : "200",
			"codestring" : "OK",
			"nchan_id" : "набор англ буквофицр вырезал",
			"realplexor_id" : "одинаковый с нчан_ид",
			"user_id" : "7 цифр вырезал"
		}

	*/
	global user_id := % oJSON.user_id
	;deviceid := вырезал
	;msgbox, % deviceid
	;global nchanid := % oJSON.nchan_id
	;сначала я думал, что нчан(одинаков с реалплексор) это и есть slnet.. но slnet в куки был
	global slnet := slnt
	return slnet
	;global admin := "https://developer.starline.ru/json/v1/device/" deviceid "/set_param"
}
return
;получаем девайсид, точнее всю инфу об устройстве, а там есть девайс ид.
;сохраним один раз девайсид в глобал, чтоб не запрашивать 24\7 запросы на девайсид и за эту функцию можно забыть
getdeviceid()
{
	global user_id
	sl_dvid := "https://developer.starline.ru/json/v3/user/" user_id "/data"
	ComObjError(false)
	w := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	w.SetTimeouts(3000, 3000, 7000, 7000)
	w.Open("GET", sl_dvid, true)
	;w.setRequestHeader("token", token)
	slnet:=webauth()
	w.setRequestHeader("Cookie", "slnet=" slnet)
	w.Send(data)
	w.WaitForResponse()
	;msgbox, % w.ResponseText()
	jsontext := % w.ResponseText 
	;msgbox, getdvid: %jsontext%
	JSON = 
		(LTrim Join 
			%jsontext% 
		)		
	;msgbox, dv: %JSON%
	htmldoc := ComObjCreate("htmlfile") 
	Script := htmldoc.Script 
	Script.execScript(" ", "JScript")
	oJSON := Script.eval("(" . JSON . ")") 	
	;deviceid := % oJSON.user_data.devices.0.device_id
	;msgbox, dvid: %deviceid%
	return deviceid
}
return
;не помню зачем, но что-то хотел делать с оповещаниями
/*
chek:
{
	Alar:=notification[alarm]
	msgbox, chek Alar: %Alar%
	if Alar=1
	{
		SetTimer, Alarm, on
	}
	else if Alar=2
	{
		SetTimer, Alarm, on
	}
	else
		SetTimer, Alarm, off
	;msgbox, Alar %Alar%
}
return
*/


;для вк, отправка и чтения диалога
#include vk.ahk
#include api.ahk