#NoEnv
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetKeyDelay, 10
SetTitleMatchMode, 2
iconPath = %A_Temp%\psIcon.dll
FileInstall, psIcon.dll, %iconPath%, 1
Menu, Tray, Icon, %iconPath%, 1

comma := False
period := False
Return

IME_GET(WinTitle="A")  {
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
	    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	    NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
          ,  Int, 0)      ;lParam  : 0
}

^sc07B::
    comma ^= True
    period ^= True
    x := ((comma << 1) | period) + 1
    Menu, Tray, Icon, %iconPath%, %x%
    TrayTip,, Swiched Punctuation Mode
Return

#If IME_Get()
    ,::
        SendRaw, % comma ? "，" : "、"
    Return

    .::
        SendRaw, % period ? "．" : "。"
    Return
