; PotPlayer: Dynamically track current playback speed. 
; Long press Right Arrow for 3x speed, release to restore original speed.

#Requires AutoHotkey v2.0

; Initialize global variable to track speed. 
; 10 represents 1.0x (using integers to avoid floating-point precision issues).
global CurrentSpeed := 10

#HotIf WinActive("ahk_class PotPlayer64 ahk_exe PotPlayerMini64.exe")

; -----------------------------------------------------------------------
; 1. Key Interception: Record daily playback speed changes.
; (The ~ prefix allows the key to be sent to PotPlayer while AHK listens)
; -----------------------------------------------------------------------

~z:: {
    global CurrentSpeed := 10  ; 'z' resets speed to 1.0x
}

~c:: {
    global CurrentSpeed += 1   ; 'c' increases speed by 0.1x (+1 in logic)
}

~x:: {
    global CurrentSpeed -= 1   ; 'x' decreases speed by 0.1x (-1 in logic)
}

; -----------------------------------------------------------------------
; 2. Core Logic: Handle long press on Right Arrow
; -----------------------------------------------------------------------

$Right:: {
    global CurrentSpeed
    
    ; Long press detection (0.3 seconds)
    if !KeyWait("Right", "T0.3") {
        
        ; Target speed is 3.0x (represented as 30)
        targetSpeed := 30
        diff := targetSpeed - CurrentSpeed
        
        ; If current speed is below 3x, send 'c' the required number of times
        if (diff > 0) {
            Send("{c " diff "}") 
        }


        ; -----------------------------------------------------------------------
        ; If you want to see a tip when activating the feature, delete the "; " before the "; ToolTip(">>> 3.0x")".
        ; -----------------------------------------------------------------------
        ; ToolTip(">>> 3.0x")
        
        ; Wait indefinitely until the Right Arrow key is released
        KeyWait("Right")
        
        ; --- RESTORE ORIGINAL SPEED ON RELEASE ---
        
        ; Step 1: Force reset to 1.0x first
        Send("z") 
        
        ; Step 2: Compensate based on the stored CurrentSpeed
        if (CurrentSpeed > 10) {
            ; If original speed was > 1.0x, send 'c' to catch up
            Send("{c " (CurrentSpeed - 10) "}") 
        } else if (CurrentSpeed < 10) {
            ; If original speed was < 1.0x, send 'x' to slow down
            Send("{x " (10 - CurrentSpeed) "}") 
        }
        
        ToolTip() ; Clear the tooltip
    } 
    ; If it's a short press, send the normal Right Arrow key (seek forward)
    else {
        Send("{Right}")
    }
}

#HotIf
