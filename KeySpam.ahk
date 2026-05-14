#Requires AutoHotkey v2.0

; --- GUI Setup ---
myGui := Gui("+AlwaysOnTop", "Key Spammer")
myGui.BackColor := "1a1a2e"

tabs := myGui.Add("Tab3", "x0 y0 w320 h460 Background1a1a2e", ["Spammer", "Key Select", "Delay", "Notes"])
tabs.SetFont("c8ab4c8 s9 bold", "Consolas")

; ── TAB 1: Spammer ──
tabs.UseTab(1)

myGui.SetFont("s13 bold", "Consolas")
myGui.Add("Text", "x20 y38 cWhite", "KEY SPAMMER")

myGui.SetFont("s9 norm", "Consolas")
myGui.Add("Text", "x20 y62 c888888", "F1 on  |  F2 off  |  F3 quit")

myGui.SetFont("s11 bold", "Consolas")
statusLight := myGui.Add("Text", "x20 y92 w260 h28 c444444", "⬤  DISABLED")

; Stats boxes
myGui.SetFont("s8 bold", "Consolas")
myGui.Add("Text", "x20 y128 c666666", "TOTAL PRESSED")
myGui.Add("Text", "x165 y128 c666666", "THIS CYCLE")
pressCount := myGui.Add("Edit", "x20 y144 w120 h28 ReadOnly Background0d0d1f c00ff88", "0")
pressCount.SetFont("s11 bold", "Consolas")
cycleCount := myGui.Add("Edit", "x165 y144 w115 h28 ReadOnly Background0d0d1f c00ff88", "0")
cycleCount.SetFont("s11 bold", "Consolas")

myGui.Add("Text", "x20 y180 c666666", "CURRENT SPEED")
speedDisplay := myGui.Add("Edit", "x20 y196 w260 h28 ReadOnly Background0d0d1f c00ff88", "1000 ms")
speedDisplay.SetFont("s11 bold", "Consolas")

; Hint label
myGui.SetFont("s8 norm", "Consolas")
myGui.Add("Text", "x20 y228 c555555", "1000 ms = 1 second  |  500 ms = 2x per sec")

; Mode dropdown
myGui.SetFont("s8 bold", "Consolas")
myGui.Add("Text", "x20 y248 c666666", "SPEED MODE")
modeDropdown := myGui.Add("DropDownList", "x20 y264 w260 Background0d0d1f c00ff88 Choose1", ["Slider","Custom"])
modeDropdown.SetFont("s10 bold", "Consolas")
modeDropdown.OnEvent("Change", SwitchMode)

; Slider
sliderLabel := myGui.Add("Text", "x20 y298 c888888", "SPEED (ms delay)")
speedSlider := myGui.Add("Slider", "x20 y314 w260 h30 Range100-5000 TickInterval500 ToolTip", 1000)
speedSlider.OnEvent("Change", UpdateSliderSpeed)
sliderFastLabel := myGui.Add("Text", "x20 y348 c555555", "100ms")
sliderSlowLabel := myGui.Add("Text", "x255 y348 c555555", "5000ms")

; Custom speed box (hidden by default)
customLabel := myGui.Add("Text", "x20 y298 c888888", "CUSTOM SPEED (ms)")
customSpeed := myGui.Add("Edit", "x20 y314 w100 h30 Background0d0d1f c00ff88 Limit4", "1000")
customSpeed.SetFont("s11 bold", "Consolas")
customUpDown := myGui.Add("UpDown", "Range1-9999", 1000)
customSpeed.OnEvent("Change", ApplyCustomSpeed)
customLabel.Visible := false
customSpeed.Visible := false
customUpDown.Visible := false

; Active key
myGui.SetFont("s8 bold", "Consolas")
myGui.Add("Text", "x20 y385 c666666", "ACTIVE KEY")
activeKeyLabel := myGui.Add("Text", "x20 y401 c00ff88 w260", "r")
activeKeyLabel.SetFont("s11 bold", "Consolas")

; Reset total
resetBtn := myGui.Add("Button", "x20 y428 w120 h26", "RESET TOTAL")
resetBtn.SetFont("s8 bold", "Consolas")
resetBtn.OnEvent("Click", (*) => ResetTotal())

; ── TAB 2: Key Select ──
tabs.UseTab(2)

myGui.SetFont("s9 norm", "Consolas")
myGui.Add("Text", "x20 y35 c888888", "SELECTED KEY:")
selectedDisplay := myGui.Add("Text", "x115 y35 c00ff88 w100", "r")

allLetters := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
myGui.SetFont("s8 bold", "Consolas")
myGui.Add("Text", "x20 y65 c666666", "LETTERS")
ddLetters := myGui.Add("DropDownList", "x20 y81 w260 Background0d0d1f c00ff88 Choose1", allLetters)
ddLetters.SetFont("s10 bold", "Consolas")
ddLetters.OnEvent("Change", (*) => SetKey(ddLetters.Text, "key"))

allNumbers := ["0","1","2","3","4","5","6","7","8","9"]
myGui.Add("Text", "x20 y125 c666666", "NUMBERS")
ddNumbers := myGui.Add("DropDownList", "x20 y141 w260 Background0d0d1f c00ff88 Choose1", allNumbers)
ddNumbers.SetFont("s10 bold", "Consolas")
ddNumbers.OnEvent("Change", (*) => SetKey(ddNumbers.Text, "key"))

allSpecials := ["!","@","#","$","%","^","&","*","(",")","-","_","=","+","[","]",";",":","'",",",".","/","~"]
myGui.Add("Text", "x20 y185 c666666", "SPECIALS")
ddSpecials := myGui.Add("DropDownList", "x20 y201 w260 Background0d0d1f c00ff88 Choose1", allSpecials)
ddSpecials.SetFont("s10 bold", "Consolas")
ddSpecials.OnEvent("Change", (*) => SetKey(ddSpecials.Text, "key"))

myGui.Add("Text", "x20 y245 c666666", "MOUSE BUTTONS")
ddMouse := myGui.Add("DropDownList", "x20 y261 w260 Background0d0d1f c00ff88 Choose1", ["M1 - Left Click", "M2 - Right Click", "M3 - Middle Click"])
ddMouse.SetFont("s10 bold", "Consolas")
ddMouse.OnEvent("Change", (*) => SetMouseKey(ddMouse.Text))

myGui.Add("Text", "x20 y305 c666666", "SPECIAL KEYS")
ddSpecialKeys := myGui.Add("DropDownList", "x20 y321 w260 Background0d0d1f c00ff88 Choose1", ["Backspace", "Delete", "Enter", "Ctrl", "Shift", "Tab", "Space", "Escape", "Up", "Down", "Left", "Right"])
ddSpecialKeys.SetFont("s10 bold", "Consolas")
ddSpecialKeys.OnEvent("Change", (*) => SetSpecialKey(ddSpecialKeys.Text))

; ── TAB 3: Delay ──
tabs.UseTab(3)

myGui.SetFont("s13 bold", "Consolas")
myGui.Add("Text", "x20 y38 cWhite", "HOLD DELAY")

myGui.SetFont("s9 norm", "Consolas")
myGui.Add("Text", "x20 y62 c888888", "How long the key is held per press")

myGui.SetFont("s8 bold", "Consolas")
myGui.Add("Text", "x20 y100 c666666", "ACTIVE HOLD DELAY")
delayDisplay := myGui.Add("Edit", "x20 y116 w260 h28 ReadOnly Background0d0d1f c00ff88", "100 ms")
delayDisplay.SetFont("s11 bold", "Consolas")

myGui.Add("Text", "x20 y160 c666666", "SELECT PRESET")

btn100 := myGui.Add("Button", "x20 y176 w260 h40", "100 ms  —  Game Safe (Default)")
btn100.SetFont("s9 bold", "Consolas")
btn100.OnEvent("Click", (*) => SetHoldDelay(100))

btn50 := myGui.Add("Button", "x20 y226 w260 h40", "50 ms  —  Balanced")
btn50.SetFont("s9 bold", "Consolas")
btn50.OnEvent("Click", (*) => SetHoldDelay(50))

btn10 := myGui.Add("Button", "x20 y276 w260 h40", "10 ms  —  Fast (May Miss)")
btn10.SetFont("s9 bold", "Consolas")
btn10.OnEvent("Click", (*) => SetHoldDelay(10))

myGui.SetFont("s8 norm", "Consolas")
myGui.Add("Text", "x20 y330 c555555", "Lower = faster cycles but may not")
myGui.Add("Text", "x20 y346 c555555", "register in some games like Roblox.")

; ── TAB 4: Notes ──
tabs.UseTab(4)

myGui.SetFont("s13 bold", "Consolas")
myGui.Add("Text", "x20 y38 cWhite", "NOTES")

myGui.SetFont("s9 norm", "Consolas")
myGui.Add("Text", "x20 y62 c888888", "Saved automatically on close")

notesBox := myGui.Add("Edit", "x20 y82 w280 h300 Multi Background0d0d1f c00ff88 WantReturn")
notesBox.SetFont("s9 norm", "Consolas")

saveBtn := myGui.Add("Button", "x20 y392 w130 h30", "SAVE NOW")
saveBtn.SetFont("s8 bold", "Consolas")
saveBtn.OnEvent("Click", (*) => SaveNotes())

clearBtn := myGui.Add("Button", "x160 y392 w130 h30", "CLEAR")
clearBtn.SetFont("s8 bold", "Consolas")
clearBtn.OnEvent("Click", (*) => ClearNotes())

tabs.UseTab(0)
myGui.Show("w320 h460")
myGui.OnEvent("Close", OnClose)

; --- State ---
currentKey := "r"
currentType := "key"
pressCounter := 0
cycleCounter := 0
useCustom := false
isRunning := false
holdDelay := 100
notesFile := A_ScriptDir "\notes.txt"

; --- Notes: load or create with random greeting ---
if !FileExist(notesFile) {
    FileAppend("", notesFile)
}
savedNotes := FileRead(notesFile)
if (Trim(savedNotes) = "") {
    greetings := [
        "Hello there~ - anderdingus",
        "zeep zorp bling blorp",
        "caseoh is hungry will you be his dinner?",
        "welcome to the notes tab",
        "ITS HAMMER TIME"
    ]
    randomGreeting := greetings[Random(1, 5)]
    savedNotes := randomGreeting
    f := FileOpen(notesFile, "w")
    f.Write(savedNotes)
    f.Close()
}
notesBox.Value := savedNotes

; --- Functions ---

SaveNotes() {
    global notesBox, notesFile
    f := FileOpen(notesFile, "w")
    f.Write(notesBox.Value)
    f.Close()
}

ClearNotes() {
    global notesBox, notesFile
    notesBox.Value := ""
    if FileExist(notesFile)
        FileDelete(notesFile)
}

OnClose(*) {
    SaveNotes()
    ExitApp()
}

SetHoldDelay(ms) {
    global holdDelay, delayDisplay
    holdDelay := ms
    delayDisplay.Value := ms " ms"
}

SetSpecialKey(selection) {
    global currentKey, currentType, activeKeyLabel, selectedDisplay
    keyMap := Map(
        "Backspace", "BackSpace",
        "Delete", "Delete",
        "Enter", "Enter",
        "Ctrl", "Ctrl",
        "Shift", "Shift",
        "Tab", "Tab",
        "Space", "Space",
        "Escape", "Escape",
        "Up", "Up",
        "Down", "Down",
        "Left", "Left",
        "Right", "Right"
    )
    if keyMap.Has(selection) {
        currentKey := keyMap[selection]
        currentType := "key"
        activeKeyLabel.Value := selection
        selectedDisplay.Value := selection
    }
}

SetMouseKey(selection) {
    global currentKey, currentType, activeKeyLabel, selectedDisplay
    if (selection = "M1 - Left Click")
        currentKey := "LButton"
    else if (selection = "M2 - Right Click")
        currentKey := "RButton"
    else if (selection = "M3 - Middle Click")
        currentKey := "MButton"
    currentType := "mouse"
    activeKeyLabel.Value := selection
    selectedDisplay.Value := selection
}

SwitchMode(*) {
    global modeDropdown, speedSlider, sliderLabel, sliderFastLabel, sliderSlowLabel
    global customSpeed, customUpDown, customLabel, useCustom, speedDisplay, isRunning
    if (modeDropdown.Text = "Custom") {
        useCustom := true
        sliderLabel.Visible := false
        speedSlider.Visible := false
        sliderFastLabel.Visible := false
        sliderSlowLabel.Visible := false
        customLabel.Visible := true
        customSpeed.Visible := true
        customUpDown.Visible := true
        speedDisplay.Value := customSpeed.Value " ms"
    } else {
        useCustom := false
        sliderLabel.Visible := true
        speedSlider.Visible := true
        sliderFastLabel.Visible := true
        sliderSlowLabel.Visible := true
        customLabel.Visible := false
        customSpeed.Visible := false
        customUpDown.Visible := false
        speedDisplay.Value := speedSlider.Value " ms"
    }
    if (isRunning)
        SetTimer(SpamKey, GetDelay())
}

UpdateSliderSpeed(*) {
    global speedDisplay, speedSlider, isRunning
    speedDisplay.Value := speedSlider.Value " ms"
    if (isRunning)
        SetTimer(SpamKey, GetDelay())
}

ApplyCustomSpeed(*) {
    global speedDisplay, customSpeed, isRunning
    val := Trim(customSpeed.Value)
    if (val != "" && IsInteger(val) && Integer(val) > 0) {
        speedDisplay.Value := val " ms"
        if (isRunning) {
            SetTimer(SpamKey, 0)
            SetTimer(SpamKey, Integer(val))
        }
    }
}

GetDelay() {
    global useCustom, customSpeed, speedSlider
    if (useCustom) {
        val := Trim(customSpeed.Value)
        if (val != "" && IsInteger(val) && Integer(val) > 0)
            return Integer(val)
    }
    return speedSlider.Value
}

SetKey(k, type) {
    global currentKey, currentType, activeKeyLabel, selectedDisplay
    if (k = "")
        return
    currentKey := k
    currentType := type
    activeKeyLabel.Value := k
    selectedDisplay.Value := k
}

ResetTotal() {
    global pressCounter, pressCount
    pressCounter := 0
    pressCount.Value := "0"
}

SpamKey() {
    global currentKey, currentType, pressCounter, cycleCounter, pressCount, cycleCount, holdDelay, isRunning
    SetTimer(SpamKey, 0)
    if (currentType = "mouse") {
        Send "{" currentKey " down}"
        Sleep holdDelay
        Send "{" currentKey " up}"
    } else {
        Send "{" currentKey " down}"
        Sleep holdDelay
        Send "{" currentKey " up}"
    }
    pressCounter++
    cycleCounter++
    pressCount.Value := pressCounter
    cycleCount.Value := cycleCounter
    if (isRunning) {
        remainingDelay := Max(1, GetDelay() - holdDelay)
        Sleep remainingDelay
        SetTimer(SpamKey, -1)
    }
}

F1:: {
    global statusLight, cycleCounter, cycleCount, isRunning
    cycleCounter := 0
    cycleCount.Value := "0"
    isRunning := true
    SetTimer(SpamKey, -1)
    statusLight.Value := "⬤  ENABLED"
    statusLight.SetFont("c00ff88")
}

F2:: {
    global statusLight, currentKey, isRunning
    isRunning := false
    SetTimer(SpamKey, 0)
    Send "{" currentKey " up}"
    statusLight.Value := "⬤  DISABLED"
    statusLight.SetFont("c444444")
}

F3:: ExitApp
