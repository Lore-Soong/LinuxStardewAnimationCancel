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
PgUp::
While GetKeyState("PgUp","P") {
 SendEvent {c Down}
 sleep 10
 SendEvent {c Up}
 sleep 100
 SendEvent {r Down}{Delete Down}{RShift Down}
 sleep 10
 SendEvent {r Up}{Delete Up}{RShift Up}
 }
return