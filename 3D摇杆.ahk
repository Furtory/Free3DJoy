Process, Priority, , Realtime
#MenuMaskKey vkE8
#WinActivateForce
#InstallKeybdHook
#InstallMouseHook
#Persistent
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 2000
#KeyHistory 2000

A::
S::
D::
W::
BlockInput On
BlockInput, MouseMove
Send {MButton Down}
CoordMode, Mouse, Screen
MouseGetPos, 中键X, 中键Y
中键计时:=A_TickCount
幅度:=10
if (A_ThisHotkey="A")
{
  MouseMove, -幅度, 0, 0, R
  MouseMove, 幅度, 0, 0, R
}
else if (A_ThisHotkey="D")
{
  MouseMove, 幅度, 0, 0, R
  MouseMove, -幅度, 0, 0, R
}
else if (A_ThisHotkey="W")
{
  MouseMove, 0, -幅度, 0, R
  MouseMove, 0, 幅度, 0, R
}
else if (A_ThisHotkey="S")
{
  MouseMove, 0, 幅度, 0, R
  MouseMove, 0, =幅度, 0, R
}
DllCall("Winmm\timeBeginPeriod", "UInt", TimePeriod)
loop
{
  if GetKeyState("A", "P") and !GetKeyState("D", "P")
  {
    方向X:=-2
  }
  else if GetKeyState("D", "P") and !GetKeyState("A", "P")
  {
    方向X:=2
  }
  else if GetKeyState("A", "P") and GetKeyState("D", "P")
  {
    方向X:=0
  }
  else if !GetKeyState("A", "P") and !GetKeyState("D", "P")
  {
    方向X:=0
  }
  
  if GetKeyState("W", "P") and !GetKeyState("S", "P")
  {
    方向Y:=-2
  }
  else if GetKeyState("S", "P") and !GetKeyState("W", "P")
  {
    方向Y:=2
  }
  else if GetKeyState("W", "P") and GetKeyState("S", "P")
  {
    方向Y:=0
  }
  else if !GetKeyState("W", "P") and !GetKeyState("S", "P")
  {
    方向Y:=0
  }
  
  中键耗时:=A_TickCount-中键计时
  if (中键耗时>=3500)
  {
    速度:=1
    
    if (方向X<0)
    {
      方向X:=方向X-3
    }
    else if (方向X>0)
    {
      方向X:=方向X+3
    }
    
    if (方向Y<0)
    {
      方向Y:=方向Y-3
    }
    else if (方向Y>0)
    {
      方向Y:=方向Y+3
    }
  }
  else if (中键耗时<=1000)
  {
    速度:=6
  }
  else
  {
    速度:=6-Floor(中键耗时/1000)*2
    if (速度<1)
    {
      速度:=1
    }
    
    if (方向X<0)
    {
      方向X:=方向X-Floor(中键耗时/1000)
    }
    else if (方向X>0)
    {
      方向X:=方向X+Floor(中键耗时/1000)
    }
    
    if (方向Y<0)
    {
      方向Y:=方向Y-Floor(中键耗时/1000)
    }
    else if (方向Y>0)
    {
      方向Y:=方向Y+Floor(中键耗时/1000)
    }
  }
  
  MouseMove, 方向X, 方向Y, 0, R
  ; ToolTip %速度% %中键耗时% %方向X% %方向Y%
  loop %速度%
    DllCall("Sleep", "UInt", SleepDuration)
  
  if !GetKeyState("A", "P") and !GetKeyState("D", "P") and !GetKeyState("W", "P") and !GetKeyState("S", "P")
  {
    方向X:=0
    方向Y:=0
    DllCall("Winmm\timeEndPeriod", "UInt", TimePeriod)
    break
  }
}
Send {MButton Up}
MouseMove, 中键X, 中键Y
BlockInput, Off
BlockInput, MouseMoveOff
return