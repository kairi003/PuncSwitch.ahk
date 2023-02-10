#Requires AutoHotkey >=2.0
SetWorkingDir A_ScriptDir

;@Ahk2Exe-SetMainIcon app.ico

FileInstall "icon.dll", "icon.dll", 1
TraySetIcon("icon.dll")

cpf := 0
TraySetIcon(A_IconFile, cpf + 1)
return


IME_GET(WinTitle := "A") {
    hwnd := WinGetID(WinTitle)
    if WinActive(WinTitle) {
        cbSize := 4 + 4 + (A_PtrSize * 6) + 16
        stGTI := Buffer(cbSize, 0) ; GUITHREADINFO stGTI
        NumPut("UInt", cbSize, stGTI) ; DWORD cbSize
        if DllCall("GetGUIThreadInfo", "Uint", 0, "Ptr*", stGTI.Ptr)
            hwnd := NumGet(stGTI, 8 + A_PtrSize, "UInt") ; HWND  hwndFocus
    }
    imeHwnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hwnd)
    WM_IME_CONTROL:= 0x0283
    IMC_GETOPENSTATUS := 0x0005
    return SendMessage(WM_IME_CONTROL, IMC_GETOPENSTATUS, 0, imeHwnd)
}


^sc07B:: {
    global cpf
    cpf := ~cpf & 3
    TraySetIcon(A_IconFile, cpf + 1)
    TrayTip("Swiched Punctuation Mode", unset, "Mute")
    return
}

#HotIf IME_Get()
,::Send(cpf&1 ? "，" : "、")
.::Send(cpf&2 ? "．" : "。")