#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=tizachar.ico
#AutoIt3Wrapper_Res_LegalCopyright=Nazar Mammedov
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <MsgBoxConstants.au3>
#include <ColorConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <Misc.au3>
#include <File.au3>
#include <TrayConstants.au3>

Global $windowvisible = False
Global $hGUI = 0
Global $processWindow = 0
Global $commands_count = 0
Global $hSelectedListView = 0
Global $addingnew = False
Global $filename = "tizachar.txt"
Global $maxID = 0

#Region ### START Koda GUI section ###
$frmEdit = GUICreate("Edit command", 595, 277, 192, 124)
$lblID = GUICtrlCreateLabel("ID", 16, 8, 15, 17)
$txtID = GUICtrlCreateInput("", 80, 8, 137, 21)
$txtLabel = GUICtrlCreateInput("", 80, 40, 137, 21)
$Label1 = GUICtrlCreateLabel("ID", 16, 40, 27, 17)
$txtKod = GUICtrlCreateInput("", 320, 8, 185, 21)
$Label2 = GUICtrlCreateLabel("Code", 264, 8, 23, 17)
$txtCode = GUICtrlCreateInput("", 80, 72, 137, 21)
$Label3 = GUICtrlCreateLabel("Key", 16, 72, 40, 17)
$txtKey = GUICtrlCreateInput("", 80, 72, 137, 21)
$txtNote = GUICtrlCreateInput("", 320, 40, 185, 21)
$Label4 = GUICtrlCreateLabel("Tag", 264, 40, 29, 17)
$Label5 = GUICtrlCreateLabel("Function", 264, 72, 46, 17)
$txtFunction = GUICtrlCreateInput("", 320, 72, 185, 21)
$Label6 = GUICtrlCreateLabel("Program", 16, 104, 57, 17)
$txtProgram = GUICtrlCreateInput("", 80, 104, 449, 21)
$Label7 = GUICtrlCreateLabel("Parameter", 16, 136, 46, 17)
$txtParam = GUICtrlCreateInput("", 80, 136, 449, 21)
$txtColor = GUICtrlCreateInput("", 80, 168, 185, 21)
$Label8 = GUICtrlCreateLabel("Color", 16, 168, 30, 17)
$Label9 = GUICtrlCreateLabel("Group", 16, 200, 32, 17)
$txtGroup = GUICtrlCreateInput("", 80, 200, 185, 21)
$Label10 = GUICtrlCreateLabel("Password", 16, 232, 28, 17)
$txtPassword = GUICtrlCreateInput("", 80, 232, 185, 21)
$btnClose = GUICtrlCreateButton("Close", 496, 240, 75, 25)
$btnDelete = GUICtrlCreateButton("Delete", 408, 240, 75, 25)
$btnSave = GUICtrlCreateButton("Save", 320, 240, 75, 25)
$btnBrowseProgram = GUICtrlCreateButton("Choose", 536, 104, 51, 25)
$btnBrowseParam = GUICtrlCreateButton("Choose", 536, 136, 51, 25)
$btnChooseColor = GUICtrlCreateButton("Choose", 280, 168, 51, 25)
#EndRegion ### END Koda GUI section ###

#Region ###
Global $idShow = TrayCreateItem("Show")
Global $idExit = TrayCreateItem("Exit")
Opt("TrayMenuMode", 3)
#EndRegion ###

PrepareArray()
CreateWindow()
GUISetIcon("tizacar.ico")
TraySetIcon("tizacar.ico")

While 1
	Sleep(50)
	Switch TrayGetMsg()
		Case $idShow
			ShowFunctions()
		Case $idExit
			Exit
	EndSwitch
WEnd


Func PrepareArray()
	Local $arrLines
	_FileReadToArray($filename, $arrLines)
	Global $arrCommands[UBound($arrLines) - 1][11]
	Global $arrCommandsNew[50][11]
	$commands_count = UBound($arrLines) - 1
	For $i = 2 To UBound($arrLines) - 1
		If (StringLen($arrLines[$i]) > 0) Then
			$arrFields = StringSplit($arrLines[$i], ";")
			If Int($arrFields[1]) > $maxID Then
				$maxID = Int($arrFields[1])
			EndIf
			$arrCommands[$i - 2][0] = $arrFields[1] ;
			$arrCommands[$i - 2][1] = $arrFields[2]
			$arrCommands[$i - 2][2] = $arrFields[3]
			$arrCommands[$i - 2][3] = $arrFields[4]
			$arrCommands[$i - 2][4] = $arrFields[5]
			$arrCommands[$i - 2][5] = $arrFields[6]
			$arrCommands[$i - 2][6] = $arrFields[7]
			$arrCommands[$i - 2][7] = $arrFields[8]
			$arrCommands[$i - 2][8] = $arrFields[9]
			$arrCommands[$i - 2][9] = $arrFields[10]
			$arrCommands[$i - 2][10] = $arrFields[11]
		EndIf
	Next
EndFunc   ;==>PrepareArray

Func RefreshData()
	GUISetState(@SW_HIDE, $hGUI)
	$windowvisible = False
	ShowTip("Updating.. Please wait", 500)
	PrepareArray()
	For $v = 1 To 4
		Local $lv = Eval("idListview" & $v)
		_GUICtrlListView_DeleteAllItems($lv)
		_GUICtrlListView_SetExtendedListViewStyle($lv, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)
		_GUICtrlListView_SetOutlineColor($lv, 0xFF00FF)
		Local $i1 = ($v - 1) * 28
		Local $i2 = $i1 + 27
		For $i = $i1 To $i2
			If $i < $commands_count - 1 Then
				If $arrCommands[$i][0] <> "0" Then
					Local $hItem = GUICtrlCreateListViewItem($arrCommands[$i][1] & "|" & $arrCommands[$i][3] & "|" & $arrCommands[$i][4], $lv)
					GUICtrlSetBkColor($hItem, $arrCommands[$i][8])
					HotKeySet($arrCommands[$i][2], "HotKeyPressed")
				EndIf
			EndIf
		Next
	Next
	GUISetState(@SW_SHOW, $hGUI)
	$windowvisible = True
EndFunc   ;==>RefreshData

Func CreateWindow()
	Global $hGUI = GUICreate("Tizachar", @DesktopWidth - 40, @DesktopHeight - 100, 10, 10)
	WinSetTrans($hGUI, "", 255)
	GUISetState(@SW_HIDE, $hGUI)
	Local $iListViewWidth = 220
	Local $iListViewHeight = 580
	Global $idListview1 = GUICtrlCreateListView("ID|CODE|ACTION", 10, 10, $iListViewWidth, $iListViewHeight) ;,$LVS_SORTDESCENDING)
	Global $idListview2 = GUICtrlCreateListView("ID|CODE|ACTION", 20 + $iListViewWidth, 10, $iListViewWidth, $iListViewHeight) ;,$LVS_SORTDESCENDING)
	Global $idListview3 = GUICtrlCreateListView("ID|CODE|ACTION", 30 + $iListViewWidth * 2, 10, $iListViewWidth, $iListViewHeight) ;,$LVS_SORTDESCENDING)
	Global $idListview4 = GUICtrlCreateListView("ID|CODE|ACTION", 40 + $iListViewWidth * 3, 10, $iListViewWidth, $iListViewHeight) ;,$LVS_SORTDESCENDING)
	Global $idKod = GUICtrlCreateInput("", 10, 620, 500, 20)
	Global $idBtnNew = GUICtrlCreateButton("New", 770, 620)
	Global $idBtnEdit = GUICtrlCreateButton("Edit", 820, 620)
	Global $idBtnClose = GUICtrlCreateButton("Close", 890, 620)
	For $v = 1 To 4
		Local $lv = Eval("idListview" & $v)
		_GUICtrlListView_SetExtendedListViewStyle($lv, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)
		_GUICtrlListView_SetOutlineColor($lv, 0xFF00FF)
		Local $i1 = ($v - 1) * 28
		Local $i2 = $i1 + 27
		For $i = $i1 To $i2
			If $i < $commands_count - 1 Then
				Local $hItem = GUICtrlCreateListViewItem($arrCommands[$i][1] & "|" & $arrCommands[$i][3] & "|" & $arrCommands[$i][4], $lv)
				GUICtrlSetBkColor($hItem, $arrCommands[$i][8])
				HotKeySet($arrCommands[$i][2], "HotKeyPressed")
			EndIf
		Next
	Next

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
EndFunc   ;==>CreateWindow

Func HotKeyPressed()
	For $i = 0 To $commands_count - 1
		$key = $arrCommands[$i][2]
		$function = $arrCommands[$i][5]
		$param = $arrCommands[$i][7]
		$check = ($key = @HotKeyPressed)
		If $check Then
			If StringLen($function) > 0 And StringLen($param) > 0 Then
				Call($function, $param)
			ElseIf StringLen($function) > 0 Then
				Call($function)
			EndIf
			ExitLoop
		EndIf
	Next
EndFunc   ;==>HotKeyPressed

Func PerformFunction()
	Global $kod = GUICtrlRead($idKod)
	$intK = Int($kod)
	Local $strK = $kod
	Local $args = ""
	Local $iPosition = StringInStr($kod, " ")
	If $iPosition > 0 Then
		$args = StringMid($kod, $iPosition + 1)
		$strK = StringLeft($kod, $iPosition - 1)
	EndIf
	For $i = 0 To $commands_count - 1
		$code = $arrCommands[$i][1]
		$key = $arrCommands[$i][2]
		$keyword = $arrCommands[$i][3]
		$function = $arrCommands[$i][5]
		$program = $arrCommands[$i][6]
		$param = $arrCommands[$i][7]
		$password = $arrCommands[$i][10]
		$check = False
		If $intK > 0 Then
			$check = (Int($code) = $intK)
		Else
			$check = $keyword = $strK
		EndIf
		If $check Then
			If StringLen($password) > 0 Then
				Local $sPasswd = InputBox("Access check", "Please enter password", "", "*")
				If $sPasswd <> $password Then
					Exit
				EndIf
			EndIf
			RunFunction($function, $program, $param, $args)
			ExitLoop
		EndIf
	Next
	$windowvisible = False
	GUISetState(@SW_HIDE, $hGUI)
EndFunc   ;==>PerformFunction

Func RunFunction($function, $program, $param, $args)
	If $function = "Run" Then
		ShellExecute($program, $param)
	ElseIf StringLen($args) > 0 Then
		Call($function, $args)
	ElseIf StringLen($function) > 0 And StringLen($param) > 0 Then
		Call($function, $param)
	Else
		Call($function)
	EndIf
EndFunc   ;==>RunFunction

Func ShowFunctions()
	If $windowvisible Then
		GUISetState(@SW_HIDE, $hGUI)
		$windowvisible = False
	Else
		GUISetState(@SW_SHOW, $hGUI)
		WinActivate($hGUI)
		Local $hInput = ControlGetHandle("", "", $idKod)
		GUICtrlSetData($idKod, "")
		_WinAPI_SetFocus($hInput)
		$windowvisible = True
		While 1
			$aMsg = GUIGetMsg(1)
			If $aMsg[1] = $hGUI Then
				Switch $aMsg[0]
					Case $idKod
						PerformFunction()
						ExitLoop
					Case $GUI_EVENT_CLOSE
						$windowvisible = False
						GUISetState(@SW_HIDE, $hGUI)
						ExitLoop
					Case $idBtnEdit
						$addingnew = False
						EditCommand()
					Case $idBtnNew
						$addingnew = True
						EditCommand()
					Case $idBtnClose
						$windowvisible = False
						GUISetState(@SW_HIDE, $hGUI)
						ExitLoop
				EndSwitch
			EndIf
		WEnd
	EndIf
EndFunc   ;==>ShowFunctions

Func ExitScript()
	;FileSave()
	Exit
EndFunc   ;==>ExitScript

Func EditCommand()
	GUISetState(@SW_SHOW, $frmEdit)
	If $addingnew = False Then
		LoadCommand()
	Else
		GUICtrlSetData($txtID, $maxID + 1)
		GUICtrlSetData($txtLabel, "")
		GUICtrlSetData($txtKey, "")
		GUICtrlSetData($txtKod, "")
		GUICtrlSetData($txtNote, "")
		GUICtrlSetData($txtFunction, "")
		GUICtrlSetData($txtProgram, "")
		GUICtrlSetData($txtParam, "")
		GUICtrlSetData($txtColor, "0xFFFFFF")
		GUICtrlSetBkColor($txtColor, "0xFFFFFF")
		GUICtrlSetData($txtGroup, "")
		GUICtrlSetData($txtPassword, "")
	EndIf
	While 1
		$aMsg = GUIGetMsg(1)
		If $aMsg[1] = $frmEdit Then
			Switch $aMsg[0]
				Case $GUI_EVENT_CLOSE
					GUISetState(@SW_HIDE, $frmEdit)
					ExitLoop
				Case $btnSave
					SaveCommand()
				Case $btnDelete
					DeleteCommand()
				Case $btnBrowseProgram
					BrowseProgram()
				Case $btnBrowseParam
					BrowseParam()
				Case $btnChooseColor
					ChooseColor()
				Case $btnClose
					GUISetState(@SW_HIDE, $frmEdit)
					ExitLoop
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>EditCommand

Func LoadCommand()
	Local $kod = 0
	If $hSelectedListView Then
		Local $count = _GUICtrlListView_GetSelectedCount($hSelectedListView)
		If $count > 0 Then
			Local $arrIndices = _GUICtrlListView_GetSelectedIndices($hSelectedListView, True)
			Local $selItemIndex = $arrIndices[1]
			Local $arrItem = _GUICtrlListView_GetItem($hSelectedListView, $selItemIndex)
			$kod = $arrItem[3]
			ConsoleWrite($kod)
		EndIf
	EndIf
	Local $index = 0
	For $i = 0 To $commands_count - 1
		If $arrCommands[$i][1] = $kod Then
			$index = $i
			ExitLoop
		EndIf
	Next
	GUICtrlSetData($txtID, $arrCommands[$index][0])
	GUICtrlSetData($txtLabel, $arrCommands[$index][1])
	GUICtrlSetData($txtKey, $arrCommands[$index][2])
	GUICtrlSetData($txtKod, $arrCommands[$index][3])
	GUICtrlSetData($txtNote, $arrCommands[$index][4])
	GUICtrlSetData($txtFunction, $arrCommands[$index][5])
	GUICtrlSetData($txtProgram, $arrCommands[$index][6])
	GUICtrlSetData($txtParam, $arrCommands[$index][7])
	GUICtrlSetData($txtColor, $arrCommands[$index][8])
	GUICtrlSetBkColor($txtColor, $arrCommands[$index][8])
	GUICtrlSetData($txtGroup, $arrCommands[$index][9])
	;GUICtrlSetData ($txtPassword,$arrCommands[$index][10])
EndFunc   ;==>LoadCommand

Func DeleteCommand()
	Local $result = MsgBox($MB_SYSTEMMODAL + $MB_YESNO, "Delete", "Do you really want to delete this command?")
	If $result = $IDYES Then
		Global $id = GUICtrlRead($txtID)
		Local $index = 0
		For $i = 0 To $commands_count - 1
			If $arrCommands[$i][0] = $id Then
				$index = $i
				ExitLoop
			EndIf
		Next
		GUICtrlSetData($txtID, "")
		GUICtrlSetData($txtLabel, "")
		GUICtrlSetData($txtKey, "")
		GUICtrlSetData($txtKod, "")
		GUICtrlSetData($txtNote, "")
		GUICtrlSetData($txtFunction, "")
		GUICtrlSetData($txtProgram, "")
		GUICtrlSetData($txtParam, "")
		GUICtrlSetData($txtColor, "")
		GUICtrlSetData($txtGroup, "")
		GUICtrlSetData($txtPassword, "")
		$arrCommands[$index][0] = "0"
		;ConsoleWrite("Delete")
		FileSave()
	EndIf
EndFunc   ;==>DeleteCommand

Func SaveCommand()
	Local $boolSave = True
	Global $id = GUICtrlRead($txtID)
	$code = GUICtrlRead($txtLabel)
	$key = GUICtrlRead($txtKey)
	$keyword = GUICtrlRead($txtKod)
	$note = GUICtrlRead($txtNote)
	$function = GUICtrlRead($txtFunction)
	$program = GUICtrlRead($txtProgram)
	$param = GUICtrlRead($txtParam)
	$color = GUICtrlRead($txtColor)
	$group = GUICtrlRead($txtGroup)
	$password = GUICtrlRead($txtPassword)
	Local $index = -1
	For $i = 0 To $commands_count - 1
		If $arrCommands[$i][0] = $id Then
			$index = $i
			ExitLoop
		EndIf
	Next
	If $id = "0" Then
		MsgBox($MB_SYSTEMMODAL, "Error", "ID cannot be 0")
		$boolSave = False
	EndIf
	If StringLen($code) = 0 Then
		MsgBox($MB_SYSTEMMODAL, "Error", "Code cannot be blank")
		$boolSave = False
	EndIf
	If StringLen($function) = 0 Then
		MsgBox($MB_SYSTEMMODAL, "Error", "Function cannot be blank")
		$boolSave = False
	EndIf
	If $index > -1 Then
		If $boolSave Then
			$arrCommands[$index][0] = $id
			$arrCommands[$index][1] = GUICtrlRead($txtLabel)
			$arrCommands[$index][2] = GUICtrlRead($txtKey)
			$arrCommands[$index][3] = GUICtrlRead($txtKod)
			$arrCommands[$index][4] = GUICtrlRead($txtNote)
			$arrCommands[$index][5] = GUICtrlRead($txtFunction)
			$arrCommands[$index][6] = GUICtrlRead($txtProgram)
			$arrCommands[$index][7] = GUICtrlRead($txtParam)
			$arrCommands[$index][8] = GUICtrlRead($txtColor)
			$arrCommands[$index][9] = GUICtrlRead($txtGroup)
			If StringLen(GUICtrlRead($txtPassword)) > 0 Then
				$arrCommands[$index][10] = GUICtrlRead($txtPassword)
			EndIf
			FileSave()
		EndIf
	Else
		Local $index = 0
		For $i = 0 To UBound($arrCommandsNew) - 1
			If StringLen($arrCommandsNew[$i][0]) = 0 Then
				$index = $i
				ExitLoop
			EndIf
		Next
		If $boolSave Then
			$arrCommandsNew[$index][0] = $id
			$arrCommandsNew[$index][1] = GUICtrlRead($txtLabel)
			$arrCommandsNew[$index][2] = GUICtrlRead($txtKey)
			$arrCommandsNew[$index][3] = GUICtrlRead($txtKod)
			$arrCommandsNew[$index][4] = GUICtrlRead($txtNote)
			$arrCommandsNew[$index][5] = GUICtrlRead($txtFunction)
			$arrCommandsNew[$index][6] = GUICtrlRead($txtProgram)
			$arrCommandsNew[$index][7] = GUICtrlRead($txtParam)
			$arrCommandsNew[$index][8] = GUICtrlRead($txtColor)
			$arrCommandsNew[$index][9] = GUICtrlRead($txtGroup)
			If StringLen(GUICtrlRead($txtPassword)) > 0 Then
				$arrCommandsNew[$index][10] = GUICtrlRead($txtPassword)
			EndIf
			FileSave()
		EndIf
	EndIf
EndFunc   ;==>SaveCommand

Func CheckIDExists($id)

EndFunc   ;==>CheckIDExists

Func BrowseProgram()
	Local $sFileOpenDialog = FileOpenDialog("Choose a program", @ProgramFilesDir & "\", "All (*.*)", $FD_FILEMUSTEXIST, "", $frmEdit)
	If $sFileOpenDialog <> "" Then
		GUICtrlSetData($txtProgram, $sFileOpenDialog)
	EndIf
EndFunc   ;==>BrowseProgram

Func BrowseParam()
	Local $sFileOpenDialog = FileOpenDialog("Choose a folder or file", @DesktopDir & "\", "", 0, "", $frmEdit)
	If $sFileOpenDialog <> "" Then
		GUICtrlSetData($txtParam, $sFileOpenDialog)
	EndIf
EndFunc   ;==>BrowseParam

Func ChooseColor()
	Local $color = _ChooseColor(2, 0, 2, 0)
	If $color <> -1 Then
		GUICtrlSetBkColor($txtColor, $color)
		GUICtrlSetData($txtColor, $color)
	EndIf
EndFunc   ;==>ChooseColor

Func GridClicked($hListview)
	$hSelectedListView = $hListview
EndFunc   ;==>GridClicked

Func ErrorHandler($err)
	If $err Then
		ConsoleWrite("Error:" & $err)
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>ErrorHandler

Func _WindowFromPoint($iX, $iY)
	Local $stInt64, $aRet, $stPoint = DllStructCreate("long;long")
	DllStructSetData($stPoint, 1, $iX)
	DllStructSetData($stPoint, 2, $iY)
	$stInt64 = DllStructCreate("int64", DllStructGetPtr($stPoint))
	$aRet = DllCall("user32.dll", "hwnd", "WindowFromPoint", "int64", DllStructGetData($stInt64, 1))
	If @error Then Return SetError(2, @error, 0)
	If $aRet[0] = 0 Then Return SetError(3, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_WindowFromPoint

Func GetWindowTitleFromPos()
	Local $hControl, $hWin, $hOldWin, $aMousePos
	$hOldWin = ""
	$aMousePos = MouseGetPos()
	$hControl = _WindowFromPoint($aMousePos[0], $aMousePos[1])
	$hWin = _WinAPI_GetAncestor($hControl, 2)
	If $hWin <> $hOldWin Then
		TrayTip("Window Info", "Window under mouse = " & WinGetTitle($hWin), 1)
		$hOldWin = $hWin
		$processWindow = $hWin
	EndIf
EndFunc   ;==>GetWindowTitleFromPos

Func TileWindow()
	GetWindowTitleFromPos()
	WinActivate($processWindow)
	WinMove($processWindow, "", 0, 0, 200, 200)
EndFunc   ;==>TileWindow

Func TileWindows($param)
	Local $aDays = StringSplit($param, ",")
	If $aDays[0] > 0 Then
		Local $startX = 0
		Local $width = @DesktopWidth / $aDays[0]
		Local $height = @DesktopHeight - 50
		For $i = 1 To $aDays[0] ; Loop through the array returned by StringSplit to display the individual values.
			WinActivate($aDays[$i])
			WinMove($aDays[$i], "", $startX + (($i - 1) * $width), 5, $width, $height)
		Next
	EndIf
EndFunc   ;==>TileWindows


Func Paste($param)
	$p = StringReplace($param, "<br>", @CRLF)
	ClipPut($p)
EndFunc   ;==>Paste

Func FileSave()
	$strFilePath = $filename
	If FileExists($strFilePath) Then
		Local $hFileOpen = FileOpen($strFilePath, $FO_UTF8_NOBOM + $FO_OVERWRITE)
		FileWriteLine($hFileOpen, "ID;code;key;keyword;note;function;program;param;color;group;password")
		$z = 1
		For $i = 0 To $commands_count - 2
			If $arrCommands[$i][0] <> "0" Then
				$line = $z & ";" & $arrCommands[$i][1] & ";" & $arrCommands[$i][2] & ";" & $arrCommands[$i][3] & ";" & $arrCommands[$i][4] & ";"
				$line = $line & $arrCommands[$i][5] & ";" & $arrCommands[$i][6] & ";" & $arrCommands[$i][7] & ";" & $arrCommands[$i][8] & ";" & $arrCommands[$i][9] & ";"
				$line = $line & $arrCommands[$i][10]
				$z = $z + 1
				FileWriteLine($hFileOpen, $line)
			EndIf
		Next
		For $i = 0 To UBound($arrCommandsNew) - 1
			If $arrCommandsNew[$i][0] <> "0" And StringLen($arrCommandsNew[$i][0]) > 0 Then
				$line = $z & ";" & $arrCommandsNew[$i][1] & ";" & $arrCommandsNew[$i][2] & ";" & $arrCommandsNew[$i][3] & ";" & $arrCommandsNew[$i][4] & ";"
				$line = $line & $arrCommandsNew[$i][5] & ";" & $arrCommandsNew[$i][6] & ";" & $arrCommandsNew[$i][7] & ";" & $arrCommandsNew[$i][8] & ";" & $arrCommandsNew[$i][9] & ";"
				$line = $line & $arrCommandsNew[$i][10]
				FileWriteLine($hFileOpen, $line)
				$z = $z + 1
			EndIf
		Next
	EndIf
	ShowTip("File saved", 500)
EndFunc   ;==>FileSave

Func ShowTip($str, $wait = 100)
	ToolTip($str, @DesktopWidth / 2, @DesktopHeight / 2)
	Sleep($wait)
	ToolTip("")
EndFunc   ;==>ShowTip

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo

	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $idListview1 Or $idListview2 Or $idListview3 Or $idListview4
			Switch $iCode
				Case $NM_CLICK ; Sent by a list-view control when the user clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					GridClicked($hWndFrom) ; No return value
				Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					;EditCommand()
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _DebugPrint($s_Text, $sLine = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @CRLF & _
			"+======================================================" & @CRLF & _
			"-->Line(" & StringFormat("%04d", $sLine) & "):" & @TAB & $s_Text & @CRLF & _
			"+======================================================" & @CRLF)
EndFunc   ;==>_DebugPrint
