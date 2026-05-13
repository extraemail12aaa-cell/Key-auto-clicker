Heres the code for you guys to have fun with but first i must warn you all i will NOT be reading comments I will NOT be reading Issues I will NOT being reading anything i will update this IF i feel like it DONT DARE EMAIL ME
You guys feel free to do anything you like with it (i probably will forget to edit this so uh comment on the very rare chance i read it so i can re upload the code for yall)

quick note i forgot to add THIS CODE DOES CREATE FILES why does it so it can save the note pad it should only create 1 file and if not hopfully ill realize that and fix it or read issues on the off chance i actually do (dookus is not HERE)

#Requires AutoHotkey v2.0

; --- GUI Setup ---
myGui := Gui("+AlwaysOnTop", "Key Spammer")
myGui.BackColor := "1a1a2e"

tabs := myGui.Add("Tab3", "x0 y0 w320 h460 Background1a1a2e", ["Spammer", "Key Select"])

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
speedDisplay := myGui.Add("Edit", "x20 y196 w260 h28 ReadOnly Background0d0d1f c00ff88", "25 ms")
speedDisplay.SetFont("s11 bold", "Consolas")

; Mode dropdown
myGui.SetFont("s8 bold", "Consolas")
myGui.Add("Text", "x20 y234 c666666", "SPEED MODE")
modeDropdown := myGui.Add("DropDownList", "x20 y250 w260 Background0d0d1f c00ff88 Choose1", ["Slider","Custom"])
modeDropdown.SetFont("s10 bold", "Consolas")
modeDropdown.OnEvent("Change", SwitchMode)

; Slider
sliderLabel := myGui.Add("Text", "x20 y288 c888888", "SPEED (ms delay)")
speedSlider := myGui.Add("Slider", "x20 y304 w260 h30 Range5-300 TickInterval25 ToolTip", 25)
speedSlider.OnEvent("Change", UpdateSliderSpeed)
sliderFastLabel := myGui.Add("Text", "x20 y338 c555555", "Fast")
sliderSlowLabel := myGui.Add("Text", "x270 y338 c555555", "Slow")

; Custom speed box (hidden by default)
customLabel := myGui.Add("Text", "x20 y288 c888888", "CUSTOM SPEED (ms)")
customSpeed := myGui.Add("Edit", "x20 y304 w100 h30 Background0d0d1f c00ff88 Limit4", "25")
customSpeed.SetFont("s11 bold", "Consolas")
customUpDown := myGui.Add("UpDown", "Range1-999", 25)
customSpeed.OnEvent("Change", ApplyCustomSpeed)
customLabel.Visible := false
customSpeed.Visible := false
customUpDown.Visible := false

; Active key
myGui.SetFont("s8 bold", "Consolas")
myGui.Add("Text", "x20 y375 c666666", "ACTIVE KEY")
activeKeyLabel := myGui.Add("Text", "x20 y391 c00ff88 w260", "r")
activeKeyLabel.SetFont("s11 bold", "Consolas")

; Reset total
resetBtn := myGui.Add("Button", "x20 y418 w120 h26", "RESET TOTAL")
resetBtn.SetFont("s8 bold", "Consolas")
resetBtn.OnEvent("Click", (*) => ResetTotal())

; ── TAB 2: Key Select ──
tabs.UseTab(2)

myGui.SetFont("s9 norm", "Consolas")
myGui.Add("Text", "x20 y35 c888888", "SELECTED KEY:")
selectedDisplay := myGui.Add("Text", "x115 y35 c00ff88 w100", "r")

; Letters
allLetters := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
myGui.SetFont("s8 bold", "Consolas")
myGui.Add("Text", "x20 y65 c666666", "LETTERS")
ddLetters := myGui.Add("DropDownList", "x20 y81 w260 Background0d0d1f c00ff88 Choose1", allLetters)
ddLetters.SetFont("s10 bold", "Consolas")
ddLetters.OnEvent("Change", (*) => SetKey(ddLetters.Text, "key"))

; Numbers
allNumbers := ["0","1","2","3","4","5","6","7","8","9"]
myGui.Add("Text", "x20 y125 c666666", "NUMBERS")
ddNumbers := myGui.Add("DropDownList", "x20 y141 w260 Background0d0d1f c00ff88 Choose1", allNumbers)
ddNumbers.SetFont("s10 bold", "Consolas")
ddNumbers.OnEvent("Change", (*) => SetKey(ddNumbers.Text, "key"))

; Specials
allSpecials := ["!","@","#","$","%","^","&","*","(",")","-","_","=","+","[","]",";",":","'",",",".","/","~"]
myGui.Add("Text", "x20 y185 c666666", "SPECIALS")
ddSpecials := myGui.Add("DropDownList", "x20 y201 w260 Background0d0d1f c00ff88 Choose1", allSpecials)
ddSpecials.SetFont("s10 bold", "Consolas")
ddSpecials.OnEvent("Change", (*) => SetKey(ddSpecials.Text, "key"))

; Mouse buttons
myGui.Add("Text", "x20 y245 c666666", "MOUSE BUTTONS")
ddMouse := myGui.Add("DropDownList", "x20 y261 w260 Background0d0d1f c00ff88 Choose1", ["M1 - Left Click", "M2 - Right Click", "M3 - Middle Click"])
ddMouse.SetFont("s10 bold", "Consolas")
ddMouse.OnEvent("Change", (*) => SetMouseKey(ddMouse.Text))

tabs.UseTab(0)
myGui.Show("w320 h460")
myGui.OnEvent("Close", (*) => ExitApp())

; --- State ---
currentKey := "r"
currentType := "key"  ; "key" or "mouse"
pressCounter := 0
cycleCounter := 0
useCustom := false
isRunning := false

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
        if (isRunning)
            SetTimer(SpamKey, Integer(val))
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
    global currentKey, currentType, pressCounter, cycleCounter, pressCount, cycleCount
    if (currentType = "mouse") {
        Click("{" currentKey " down}")
        Sleep 100
        Click("{" currentKey " up}")
    } else {
        Send "{" currentKey " down}"
        Sleep 100
        Send "{" currentKey " up}"
    }
    pressCounter++
    cycleCounter++
    pressCount.Value := pressCounter
    cycleCount.Value := cycleCounter
}

F1:: {
    global statusLight, cycleCounter, cycleCount, isRunning
    cycleCounter := 0
    cycleCount.Value := "0"
    isRunning := true
    SetTimer(SpamKey, GetDelay())
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

DOOKUS WAS HERE....
