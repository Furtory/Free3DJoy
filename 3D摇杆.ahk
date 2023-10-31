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

Menu, Tray, Icon, %A_ScriptDir%\LOGO.ico
Menu, Tray, NoStandard ;不显示默认的AHK右键菜单
Menu, Tray, Add, 使用教程, 使用教程 ;添加新的右键菜单
Menu, Tray, Add, 自动切换, 自动切换 ;添加新的右键菜单
Menu, Tray, Add, 开机自启, 开机自启 ;添加新的右键菜单
Menu, Tray, Add
Menu, Tray, Add, 重启软件, 重启软件 ;添加新的右键菜单
Menu, Tray, Add, 退出软件, 退出软件 ;添加新的右键菜单
摇杆:=1
TG:=0
autostartLnk:=A_StartupCommon . "\Free3DJoy.lnk" ;开机启动文件的路径
IfExist, % autostartLnk ;检查开机启动的文件是否存在
{
  FileGetShortcut, %autostartLnk%, lnkTarget ;获取开机启动文件的信息
  if (lnkTarget!=A_ScriptFullPath) ;如果启动文件执行的路径和当前脚本的完整路径不一致
  {
    FileCreateShortcut, %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir% ;将启动文件执行的路径改成和当前脚本的完整路径一致
  }
  
  autostart:=1
  Menu, Tray, Check, 开机自启 ;右键菜单打勾
}
else
{
  autostart:=0
  Menu, Tray, UnCheck, 开机自启 ;右键菜单不打勾
}

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

开机自启: ;模式切换
Critical, On
if (autostart=1) ;关闭开机自启动
{
  IfExist, % autostartLnk ;如果开机启动的文件存在
  {
    FileDelete, %autostartLnk% ;删除开机启动的文件
  }
  
  autostart:=0
  Menu, Tray, UnCheck, 开机自启 ;右键菜单不打勾
}
else ;开启开机自启动
{
  IfExist, % autostartLnk ;如果开机启动的文件存在
  {
    FileGetShortcut, %autostartLnk%, lnkTarget ;获取开机启动文件的信息
    if (lnkTarget!=A_ScriptFullPath) ;如果启动文件执行的路径和当前脚本的完整路径不一致
    {
      FileCreateShortcut, %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir% ;将启动文件执行的路径改成和当前脚本的完整路径一致
    }
  }
  else ;如果开机启动的文件不存在
  {
    FileCreateShortcut, %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir% ;创建和当前脚本的完整路径一致的启动文件
  }
  
  autostart:=1
  Menu, Tray, Check, 开机自启 ;右键菜单打勾
}
Critical, Off
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
  loop 50
  {
    ToolTip 已关闭摇杆功能
    Sleep 30
  }
  ToolTip
}
else
{
  摇杆:=1
  Hotkey, A, on
  Hotkey, D, on
  Hotkey, W, on
  Hotkey, S, on
  loop 50
  {
    ToolTip 已打开摇杆功能
    Sleep 30
  }
  ToolTip
}
return

检测软件:
MouseGetPos, , , WinID
WinGetClass, WinID, ahk_id %WinID%
if (WinID=自动切换)
{
  Hotkey, A, on
  Hotkey, D, on
  Hotkey, W, on
  Hotkey, S, on
  SetTimer, 检测软件, Delete
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
  Hotkey, A, off
  Hotkey, D, off
  Hotkey, W, off
  Hotkey, S, off
  SetTimer, 检测软件, 300
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
  if (中键耗时>=3000)
  {
    速度:=10
    
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
    速度:=170-Floor(中键耗时/10)
  }
  else
  {
    速度:=40-Floor((中键耗时-1000)/50)
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