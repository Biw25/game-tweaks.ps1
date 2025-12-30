# ==========================================
# GAME TWEAKS - เมนูติ๊ก ภาษาไทย
# ==========================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "ตั้งค่า Windows สำหรับเล่นเกม"

function Line {
    Write-Host "------------------------------------------" -ForegroundColor DarkGray
}

function Ask($text) {
    Write-Host "☑ $text ? (Y/N): " -NoNewline -ForegroundColor Cyan
    return (Read-Host).ToUpper() -eq "Y"
}

Line
Write-Host "🎮 ตั้งค่า Windows สำหรับเล่นเกม (ของผมเอง)" -ForegroundColor Green
Line

# ===== Essential =====
if (Ask "สร้าง Restore Point") {
    Checkpoint-Computer -Description "Before Game Tweaks" -RestorePointType MODIFY_SETTINGS
}

if (Ask "ลบไฟล์ชั่วคราว") {
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
}

if (Ask "ปิด Telemetry (ไม่ส่งข้อมูล)") {
    New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
    Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" AllowTelemetry 0
}

if (Ask "ปิด GameDVR (เพิ่ม FPS)") {
    Set-ItemProperty "HKCU:\System\GameConfigStore" GameDVR_Enabled 0
    New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null
    Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" AllowGameDVR 0
}

if (Ask "ปิด Hibernation") {
    powercfg /hibernate off
}

# ===== Advanced =====
if (Ask "ปิดแอปเบื้องหลัง (Background Apps)") {
    Set-ItemProperty `
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" `
    GlobalUserDisabled 1
}

if (Ask "ปิด Fullscreen Optimizations (ลด input lag)") {
    Set-ItemProperty "HKCU:\System\GameConfigStore" GameDVR_FSEBehaviorMode 2
}

# ===== Preferences =====
if (Ask "ปิด Mouse Acceleration (แนะนำสำหรับ FPS)") {
    Set-ItemProperty "HKCU:\Control Panel\Mouse" MouseSpeed 0
    Set-ItemProperty "HKCU:\Control Panel\Mouse" MouseThreshold1 0
    Set-ItemProperty "HKCU:\Control Panel\Mouse" MouseThreshold2 0
}

if (Ask "แสดงนามสกุลไฟล์") {
    Set-ItemProperty `
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    HideFileExt 0
}

if (Ask "ปิด Widgets (Windows 11)") {
    Set-ItemProperty `
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    TaskbarDa 0
}

# ===== Power =====
if (Ask "ตั้ง Power Plan เป็น High Performance") {
    powercfg -setactive SCHEME_MIN
}

Line
Write-Host "✅ เสร็จแล้ว กรุณารีสตาร์ทเครื่อง" -ForegroundColor Green
Line
Pause
