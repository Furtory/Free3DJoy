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

Menu, Tray, NoStandard ;不显示默认的AHK右键菜单
Menu, Tray, Add, 使用教程, 使用教程 ;添加新的右键菜单
Menu, Tray, Add, 自动切换, 自动切换 ;添加新的右键菜单
Menu, Tray, Add
Menu, Tray, Add, 重启软件, 重启软件 ;添加新的右键菜单
Menu, Tray, Add, 退出软件, 退出软件 ;添加新的右键菜单
摇杆:=1
TG:=0

IfExist, %A_ScriptDir%\摇杆设置.ini ;如果配置文件存在则读取
{
  IniRead, 自动切换, 摇杆设置.ini, 设置, 自动切换
}
else
{
  自动切换:=0
  IniWrite, %自动切换%, 摇杆设置.ini, 设置, 自动切换
}

PgUp & PgDn::Reload
重启软件:
Reload

Home & End::ExitApp
退出软件:
ExitApp

使用教程:
MsgBox, , 3D摇杆, 黑钨重工出品 免费开源 请勿商用 侵权必究`n更多免费软件教程尽在QQ群 1群763625227 2群643763519`n"快捷打开关闭摇杆功能 Win+S"
return

自动切换:
KeyWait, LButton
loop
{
  ToolTip 请在需要自动切换的软件内点击左键以设置
  if GetKeyState("LButton", "P")
  {
    MouseGetPos, , , WinID
    WinGetClass, 自动切换, ahk_id %WinID%
    IniWrite, %自动切换%, 摇杆设置.ini, 设置, 自动切换
    break
  }
}
loop 100
{
  ToolTip 自动切换设置完成 %自动切换%
  Sleep 30
}
ToolTip
return

#s::
if (摇杆=1)
{
  摇杆:=0
  Hotkey, A, off
  Hotkey, D, off
  Hotkey, W, off
  Hotkey, S, off
}
else
{
  摇杆:=1
  Hotkey, A, on
  Hotkey, D, on
  Hotkey, W, on
  Hotkey, S, on
}
return

A::
D::
W::
S::
if (TG=1)
{
  return
}
MouseGetPos, , , WinID
WinGetClass, WinID, ahk_id %WinID%
if (WinID!=自动切换) or (WinID=0) or (WinID="")
{
  return
}
TG:=1
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
TG:=0
BlockInput, Off
BlockInput, MouseMoveOff
return