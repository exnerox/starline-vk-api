#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn UseUnsetLocal, Off

;#Include JRWTools.ahk
#Include Crypt.ahk

; This is how to create a password, and decrypt a password. You probably want to change MyHAsh to something else, think of it as the password to decrypt.
/*
AdminUser = TestThisPasswordNowTestThisPasswordNowTestThisPasswordNowTestThisPasswordNow

AdminUser := Crypt.Encrypt.StrEncrypt(AdminUser,"MyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAsh",5,1)

MsgBox, %AdminUser%
*/


AdminUser = TestThisPasswordNowTestThisPasswordNowTestThisPasswordNowTestThisPasswordNow

AdminUser := Crypt.Hash.StrHash(AdminUser,6,"MyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAshMyHAsh",7)

MsgBox, %AdminUser%
folder:="C:\"
DriveGet, list, list
DriveGet, cap, capacity, %folder%
DrivespaceFree, free, %folder%
DriveGet, fs, fs, %folder%
DriveGet, label, label, %folder%
DriveGet, serial, serial, %folder%
DriveGet, type, type, %folder%
DriveGet, status, status, %folder%
MsgBox,
(
Все диски: %list%
Выбранный диск: %folder%
Тип диска: %type%
Статус: %status%
Ёмкость: %cap% Мб
Свободное место: %free% Мб
Файловая система: %fs%
Метка тома: %label%
Серийный номер: %serial%
)