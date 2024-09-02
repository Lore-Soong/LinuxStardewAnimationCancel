 Run, "C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.exe"
#NoEnv
#Warn
#singleinstance, force
first = true

if first
{
    sleep 12000
    first = false
}
Winwait, Stardew Valley


WinWaitClose, Stardew Valley
ExitApp

#If WinActive("Stardew Valley")
XButton2::
While GetKeyState("XButton2","P") {
 SendEvent {c Down}
 sleep 10
 SendEvent {c Up}
 sleep 100
 SendEvent {r Down}{Delete Down}{RShift Down}
 sleep 10
 SendEvent {r Up}{Delete Up}{RShift Up}
 }
return