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
SetBatchLines -1
SetKeyDelay -1, -1
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen

Menu, Tray, Icon, %A_ScriptDir%\LOGO.ico
Menu, Tray, NoStandard ;不显示默认的AHK右键菜单
Menu, Tray, Add, 使用教程, 使用教程 ;添加新的右键菜单
Menu, Tray, Add, Z轴旋转, Z轴旋转 ;添加新的右键菜单
Menu, Tray, Add, 自动切换, 自动切换 ;添加新的右键菜单
Menu, Tray, Add
Menu, Tray, Add, 上下反向, 上下反向 ;添加新的右键菜单
Menu, Tray, Add, 左右反向, 左右反向 ;添加新的右键菜单
Menu, Tray, Add
Menu, Tray, Add, 开机自启, 开机自启 ;添加新的右键菜单
Menu, Tray, Add, 重启软件, 重启软件 ;添加新的右键菜单
Menu, Tray, Add, 退出软件, 退出软件 ;添加新的右键菜单
摇杆:=1
TG:=0
双击计时:=0
SleepDuration := 1  ; 这里有时可以根据下面的值进行细微调整(例如 2 与 3 的区别).
TimePeriod := 3 ; 尝试 7 或 3. 请参阅下面的注释.
; 在休眠持续时间一般向上取整到 15.6 ms 的个人电脑中, 尝试 TimePeriod:=7 来允许稍短一点的休眠, 而尝试 TimePeriod:=3 或更小的值来允许最小可能的休眠.

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
  IniRead, 旋转Y, 摇杆设置.ini, 设置, 旋转Y
  IniRead, 上下反向, 摇杆设置.ini, 设置, 上下反向
  if (上下反向)
  {
    Menu, Tray, Check, 上下反向 ;右键菜单打勾
  }
  IniRead, 左右反向, 摇杆设置.ini, 设置, 左右反向
  if (左右反向)
  {
    Menu, Tray, Check, 左右反向 ;右键菜单打勾
  }
}
else
{
  自动切换:=0
  IniWrite, %自动切换%, 摇杆设置.ini, 设置, 自动切换
  上下反向:=0
  IniWrite, %上下反向%, 摇杆设置.ini, 设置, 上下反向
  左右反向:=0
  IniWrite, %左右反向%, 摇杆设置.ini, 设置, 左右反向
  goto 使用教程
}

MouseXY(x,y) ;【鼠标移动】
{
  DllCall("mouse_event",uint,1,int,x,int,y,uint,0,int,0)
}

PgUp & PgDn::Reload
重启软件:
Reload

Home & End::ExitApp
退出软件:
ExitApp

使用教程:
MsgBox, , 3D摇杆, 黑钨重工出品 免费开源 请勿商用 侵权必究`n更多免费软件教程尽在QQ群 1群763625227 2群643763519`n`nW/A/S/D 自由旋转模型 双击加快旋转速度`nQ/E 绕视角Z轴旋转模型`nQ+E 放大模型`nA+D 缩小模型`n快捷打开关闭摇杆功能 Win+S`n`n如果更新后无法使用请删除ini文件后重启本软件
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

上下反向:
Critical, On
if (上下反向=1)
{
  上下反向:=0
  Menu, Tray, UnCheck, 上下反向 ;右键菜单不打勾
  IniWrite, %上下反向%, 摇杆设置.ini, 设置, 上下反向
}
else ;开启开机自启动
{
  上下反向:=1
  Menu, Tray, Check, 上下反向 ;右键菜单打勾
  IniWrite, %上下反向%, 摇杆设置.ini, 设置, 上下反向
}
Critical, Off
return

左右反向:
Critical, On
if (左右反向=1)
{
  左右反向:=0
  Menu, Tray, UnCheck, 左右反向 ;右键菜单不打勾
  IniWrite, %左右反向%, 摇杆设置.ini, 设置, 左右反向
}
else ;开启开机自启动
{
  左右反向:=1
  Menu, Tray, Check, 左右反向 ;右键菜单打勾
  IniWrite, %左右反向%, 摇杆设置.ini, 设置, 左右反向
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

Z轴旋转:
KeyWait, LButton
loop
{
  ToolTip 请在Z轴旋转处点击左键以设置
  if GetKeyState("LButton", "P")
  {
    MouseGetPos, , 旋转Y
    IniWrite, %旋转Y%, 摇杆设置.ini, 设置, 旋转Y
    break
  }
}
loop 100
{
  ToolTip Z轴旋转处设置完成 Y%旋转Y%
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
  Hotkey, Q, on
  Hotkey, E, on
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
  Hotkey, Q, on
  Hotkey, E, on
  SetTimer, 检测软件, Delete
}
return

a::
d::
if (TG!=1)
{
  loop 5
  {
    if GetKeyState("A", "P") and GetKeyState("D", "P")
    {
      Send {MButton Down}
      Send {LButton Down}
      loop
      {
        MouseMove, 0, 2, 0, R
        
        DllCall("Winmm\timeBeginPeriod", "UInt", TimePeriod)
        loop 5
          DllCall("Sleep", "UInt", SleepDuration)
        DllCall("Winmm\timeEndPeriod", "UInt", TimePeriod)
        
        if !GetKeyState("A", "P") or !GetKeyState("D", "P")
        {
          Send {LButton Up}
          break
        }
      }
    }
    Sleep 10
  }
}
w::
s::
if (TG=1)
{
  return
}
Critical, On
MouseGetPos, , , WinID
WinGetClass, WinID, ahk_id %WinID%
if (WinID!=自动切换) or (WinID=0) or (WinID="")
{
  Hotkey, A, off
  Hotkey, D, off
  Hotkey, W, off
  Hotkey, S, off
  Hotkey, Q, off
  Hotkey, E, off
  send {%A_ThisHotkey% Down}
  KeyWait, %A_ThisHotkey%
  send {%A_ThisHotkey% Up}
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
双击:=0
初次按下:=1
换向X:=0
换向Y:=0
if GetKeyState("A", "P")
{
  方向X:=-1
  MouseMove, -幅度, 0, 0, R
  MouseMove, 幅度, 0, 0, R
}
else if GetKeyState("D", "P")
{
  方向X:=1
  MouseMove, 幅度, 0, 0, R
  MouseMove, -幅度, 0, 0, R
}
else if GetKeyState("W", "P")
{
  方向Y:=-1
  MouseMove, 0, -幅度, 0, R
  MouseMove, 0, 幅度, 0, R
}
else if GetKeyState("S", "P")
{
  方向Y:=1
  MouseMove, 0, 幅度, 0, R
  MouseMove, 0, =幅度, 0, R
}

loop
{
  if GetKeyState("A", "P") and !GetKeyState("D", "P")
  {
    if (左右反向=1)
    {
      方向X:=1
    }
    else
    {
      方向X:=-1
    }
  }
  else if GetKeyState("D", "P") and !GetKeyState("A", "P")
  {
    if (左右反向=1)
    {
      方向X:=-1
    }
    else
    {
      方向X:=1
    }
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
    if (上下反向=1)
    {
      方向Y:=1
    }
    else
    {
      方向Y:=-1
    }
  }
  else if GetKeyState("S", "P") and !GetKeyState("W", "P")
  {
    if (上下反向=1)
    {
      方向Y:=-1
    }
    else
    {
      方向Y:=1
    }
  }
  else if GetKeyState("W", "P") and GetKeyState("S", "P")
  {
    方向Y:=0
  }
  else if !GetKeyState("W", "P") and !GetKeyState("S", "P")
  {
    方向Y:=0
  }
  
  if (旧方向X!=方向X) and (A_Index!=1)
  {
    方向X记录:=方向X
    换向X:=A_TickCount
  }
  if (旧方向Y!=方向Y) and (A_Index!=1)
  {
    方向Y记录:=方向Y
    换向Y:=A_TickCount
  }
  
  中键耗时:=A_TickCount-中键计时
  if (中键耗时<=1300)
  {
    速度:=15-Floor(中键耗时/(1000/10))
  }
  else
  {
    速度:=2
  }
  
  方向X记录:=方向X
  方向Y记录:=方向Y
  
  if (双击计时!=0)
  {
    双击检测:=A_TickCount-双击计时
    if (双击检测<250) or (双击=1)
    {
      双击:=1
      速度:=10
      
      if (方向X<0)
      {
        方向X:=方向X-4
      }
      else if (方向X>0)
      {
        方向X:=方向X+4
      }
      
      if (方向Y<0)
      {
        方向Y:=方向Y-4
      }
      else if (方向Y>0)
      {
        方向Y:=方向Y+4
      }
    }
  }
  
  ; /*
  if (换向X!=0)
  {
    换向X时间:=A_TickCount-换向X
    if (换向X时间<=1000)
    {
      减速度X:=Ceil(5-换向X时间/200)
      if (方向X<=1) and (方向X>0)
      {
        方向X:=1
      }
      else if (方向X>-1) and (方向X<0)
      {
        方向X:=-1
      }
    }
    else
    {
      减速度X:=0
    }
  }
  
  if (换向Y!=0)
  {
    换向Y时间:=A_TickCount-换向Y
    if (换向Y时间<=1000)
    {
      减速度Y:=Ceil(5-换向Y时间/200)
      if (方向Y<=1) and (方向Y>0)
      {
        方向Y:=1
      }
      else if (方向Y>-1) and (方向Y<0)
      {
        方向Y:=-1
      }
    }
    else
    {
      减速度Y:=0
    }
  }
  
  if (换向X!=0) or (换向Y!=0)
  {
    if (减速度X>减速度Y)
    {
      速度:=速度+减速度X
    }
    else if (减速度X<减速度Y)
    {
      速度:=速度+减速度Y
    }
  }
  ; */
  
  ; ToolTip %速度% %换向X时间% %换向Y时间%`n%中键耗时%ms X%方向X% Y%方向Y%`n%旧方向X% %旧方向Y%`n%A_TickCount% %换向X% %换向Y%
  MouseXY(方向X,方向Y) ;【鼠标移动】
  
  if (方向X>0)
  {
    旧方向X:=1
  }
  else if (方向X<0)
  {
    旧方向X:=-1
  }
  else
  {
    旧方向X:=0
  }
  
  if (方向Y>0)
  {
    旧方向Y:=1
  }
  else if (方向Y<0)
  {
    旧方向Y:=-1
  }
  else
  {
    旧方向Y:=0
  }
  
  DllCall("Winmm\timeBeginPeriod", "UInt", TimePeriod)
  loop %速度%
    DllCall("Sleep", "UInt", SleepDuration)
  
  if !GetKeyState("A", "P") and !GetKeyState("D", "P") and !GetKeyState("W", "P") and !GetKeyState("S", "P")
  {
    方向X:=0
    方向Y:=0
    DllCall("Winmm\timeEndPeriod", "UInt", TimePeriod)
    
    if (中键耗时<250)
    {
      双击计时:=A_TickCount
    }
    else
    {
      双击计时:=0
    }
    
    break
  }
}
Send {MButton Up}
MouseMove, 中键X, 中键Y
BlockInput, MouseMoveOff
BlockInput, Off
Critical, Off
TG:=0
return

q::
e::
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
  Hotkey, Q, off
  Hotkey, E, off
  send {%A_ThisHotkey% Down}
  KeyWait, %A_ThisHotkey%
  send {%A_ThisHotkey% Up}
  SetTimer, 检测软件, 300
  return
}
TG:=1
BlockInput On
BlockInput, MouseMove
MouseGetPos, 中键X, 中键Y
DllCall("Winmm\timeBeginPeriod", "UInt", TimePeriod)
loop 5
{
  if GetKeyState("Q", "P") and GetKeyState("E", "P")
  {
    Send {MButton Down}
    Send {LButton Down}
    loop
    {
      MouseMove, 0, -2, 0, R
      
      loop 5
        DllCall("Sleep", "UInt", SleepDuration)
    
      if !GetKeyState("Q", "P") or !GetKeyState("E", "P")
      {
        Send {MButton Up}
        Send {LButton Up}
        break
      }
    }
  }
  loop 10
    DllCall("Sleep", "UInt", SleepDuration)
}
Sleep 30
if !GetKeyState("Q", "P") and !GetKeyState("E", "P")
{
  MouseMove, 中键X, 中键Y
  BlockInput, MouseMoveOff
  BlockInput, Off
  TG:=0
  return
}
MouseMove, A_ScreenWidth/2, 旋转Y, 0
Send {MButton Down}

if GetKeyState("Q", "P")
{
  MouseMove, -幅度, 0, 0, R
  MouseMove, 幅度, 0, 0, R
}
else if GetKeyState("E", "P")
{
  MouseMove, 幅度, 0, 0, R
  MouseMove, -幅度, 0, 0, R
}

loop
{
  if GetKeyState("Q", "P") and !GetKeyState("E", "P")
  {
    MouseMove, -2, 0, 5, R
  }
  else if GetKeyState("E", "P") and !GetKeyState("Q", "P")
  {
    MouseMove, 2, 0, 5, R
  }
  else if GetKeyState("Q", "P") and GetKeyState("E", "P")
  {
    Send {MButton Up}
    MouseMove, 中键X, 中键Y
    Send {MButton Down}
    Send {LButton Down}
    loop
    {
      MouseMove, 0, -2, 0, R
      
      loop 5
        DllCall("Sleep", "UInt", SleepDuration)
    
      if !GetKeyState("Q", "P") or !GetKeyState("E", "P")
      {
        Send {MButton Up}
        Send {LButton Up}
        MouseMove, A_ScreenWidth/2, 旋转Y, 0
        Send {MButton Down}
        break
      }
    }
  }
  
  loop 5
    DllCall("Sleep", "UInt", SleepDuration)
  
  if !GetKeyState("Q", "P") and !GetKeyState("E", "P")
  {
    DllCall("Winmm\timeEndPeriod", "UInt", TimePeriod)
    break
  }
}
Send {MButton Up}
MouseMove, 中键X, 中键Y
BlockInput, MouseMoveOff
BlockInput, Off
TG:=0
return