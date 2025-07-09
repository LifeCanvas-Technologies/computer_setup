'WallpaperSwitcher (Change wallpaper every x seconds on every monitor from shuffled list)
'This script is provided as an example of how WallP.exe can be used
'Les Ferch, lesferch@gmail.com
'Requires WallP.exe (https://lesferch.github.io/WallP)

Set oWSH = CreateObject("Wscript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")
Pictures = oWSH.RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\My Pictures")

'----------------------------------------------------------------------
'Change the value below to set how often the wallpaper is changed
Const Interval = 600 'seconds

'Edit the following path to the location of your wallpaper images
'Files may be added or removed while the script is running
PicPath = Pictures & "\Wallpaper"
'----------------------------------------------------------------------

MyFolder = oFSO.GetParentFolderName(WScript.ScriptFullName)
WallPExe = MyFolder & "\WallP.exe"
If Not oFSO.FileExists(WallPExe) Then
  MsgBox "File missing: " & WallPExe,,WScript.ScriptName
  WScript.Quit
End If

oWSH.CurrentDirectory = PicPath
Temp  = oWSH.ExpandEnvironmentStrings("%Temp%")
PicListFile = Temp & "\PicList.txt"

Dim ArrPic, UB 'Global variables

Sub GetShuffledList
  oWSH.Run "Cmd /c dir /b>" & """" & PicListFile & """",0,True
  Set oFile = oFSO.GetFile(PicListFile)
  If oFile.Size = 0 Then
    MsgBox "No files found in " & PicPath,,WScript.ScriptName
    WScript.Quit
  End If
  FileContents = oFSO.OpenTextFile(PicListFile).ReadAll
  ArrPic = Split(FileContents,VBCRLF)
  Randomize
  UB = UBound(ArrPic) - 1
  For i = 0 To UB
    j = Int((UB + 1) * Rnd)
    x = ArrPic(i)
    ArrPic(i) = ArrPic(j)
    ArrPic(j) = x
  Next
End Sub

Do
  GetShuffledList
  For i = 0 To UB
    If oFSO.FileExists(ArrPic(i)) Then
      oWSH.Run """" & WallPExe & """ """ & PicPath & "\" & ArrPic(i) & """",0,False
      WScript.Sleep Interval * 1000
    End If
  Next
Loop
