#STARDEW AUTO-CANCEL SCRIPT!

  #DEPENDENCIES: xdotool, wmctrl, xinput

#INSTRUCTIONS

#move this script, KillGOR.sh RestoreGOR.sh, to the location "~/.scripts" on your linux system if it doesn't exist create one

#STEAM LAUNCH OPTIONS https://help.steampowered.com/en/faqs/view/7D01-D2DD-D75E-2955
  #RUN WITHOUT TERMINAL AND AUTO START ON GAME START
    #[gamemoderun %command% & ~/.scripts/Stardew.sh] (no brackets)
      #OR [gamemoderun %command% & ~/.scripts/Stardew.sh > ~/.scripts/output.txt] and use [tail -f ~/.scripts/output.txt] in a seperate terminal to Debug issues (also no brackets)

#GameOverlay prevents running Scripts in a terminal window on game start using LAUNCH OPTIONS comment this out with a # if you run the script manually
#The link to this script is on this scripts GitHub Page - it just changes the name of GameOverlayRender.so to GOR64.so and GOR32.so and restores it at the end of this script
. ~/.scripts/KillGOR.sh


#=============OPTIONS=============#
  #Set the time before the script starts to keep the script running while Stardew Starts up
timer=18

  #when true This Prevents the Program from exiting and does not clear the scripts output as it runs
log=false

  #Sets this to match the window decoration Title of Stardew
win="Stardew Valley"

  #exclude your browser in window search
browser="Waterfox"

#====IMPORTATNT PLEASE SET THESE VARIABLES TO ALLOW THE SCRIPT TO WORK FOR YOU===#

  #My Default = Logitech G500s Laser Gaming Mouse Keyboard	id=18 Key112 = PGup
  #use [xinput list] (no brackets) to determine which device you are using Auto Cancel (Keyboard, Mouse, Controller etc.)to get the DEVICE ID
devid=18

  #to determine the keyboard/mouse button/key ID
  #use [sleep 5; xinput query-state "DEVICE ID"] (no brackets or quotations) Hold down the desired key before the 5 second duration is up and scroll through the output
  #to see which key/button ID You were holding the output line you are looking for will look like this key[112]=down or button[1]=down
buttorkey=key #if the output of [sleep 5; xinput query-state "DEVICE ID"] was a key or button set accordingly

  #Key ID number from the output of [sleep 5; xinput query-state "DEVICE ID"]
key=112
  #Case Sensitivity
down=down #Set to "Down" if [sleep 5; xinput query-state "DEVICE ID"] output was "key[112]=Down"

up=up #Set to "Up" if [sleep 5; xinput query-state "DEVICE ID"] output was "key[112]=Up" check the surrounding keys to determine which to use

#===============END===============#
echo "WAITING "$timer" SECONDS FOR "$win" TO START..."

sleep $timer

clear

echo "ANIMATION CANCEL SCRIPT: PRESS DEVICE ID "$devid": "$buttorkey":"$key" TO ACTIVATE"

nofocus=false

pressed=false

pass1=true
#togglable logging to prevent Output Clutter 
logging()
{
  if [ $log = false ] && [ $pass1 = false ]; then
    clear
    echo "AWAITING INPUT..."
    pass1=true
  fi
}
#Determines window Focus
checkfocus()
{
    if [ $nofocus = false ]; then
        echo $win" LOST FOCUS PAUSING SCRIPT"
    fi
}
#actual Animation Cancel Logic
pressTool()
{
  xdotool keydown 'c'
  sleep 0.090
  xdotool keyup 'c'
  sleep 0.042
  xdotool keydown 'Shift_R+Delete+R'
  sleep 0.005
  xdotool keyup 'Shift_R+Delete+R'
  logging
  pass1=false
  echo "Cancel Key Presed"
}
#infinite loop to contiously check if Game Exists and if the window is active
while :
  do
    #check if Game exists
    if wmctrl -l | grep "$win" | grep -v "$browser" > /dev/null; then
      #save active window to variable
      curwin="$(xdotool getwindowfocus getwindowname | uniq)"
      #check if active window is the same as the Game Named above
      if [ "$curwin" = "$win" ]; then
        #Sets nofocus to false because confirmed Game is active window
        nofocus=false
        #if exists and focused then check if the Specified key is down if so Animation Cancel
        while xinput query-state $devid | grep "$buttorkey\[$key\]=$down" > /dev/null; do pressTool; done
        #When the Specified key is realeased and the specified key has been pressed at least once clear the output if logging is false
        if xinput query-state $devid | grep "$buttorkey\[$key\]=$up" > /dev/null && [ $pass1 = false ]; then
          logging
        fi
      #this only gets executed if the game is not active
      else
        #clear output if logging is false
        logging
        #tell the user that the game window has lost focus
        checkfocus
        #Set noFocus to true to prevent the user from bein spammed loss of focus output
        nofocus=true
        #wait 2 seconds to prevent the program from infinitely looping too fast when not focused
        sleep 2
      fi
    #Only executes if the Game window does not exist 
    else
      #clear the output
      clear
      #Restore the GameOverlayRender.so to allow use for other games
      . ~/.scripts/RestoreGOR.sh
      #Tell the user that the game has closed
      echo $win" HAS CLOSED"
      #allow for 5 seconds for the user to read the output
      sleep 5
      #if logging is not enabled just exit the program
      if [ $log = false ]; then
        exit
      fi  
    fi
  done
