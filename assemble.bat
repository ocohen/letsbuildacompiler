@echo off
setlocal

for /F "tokens=1 delims=." %%a in ("%1") do (
    set filename="%%a"
)


nasm -f win32 harness.asm
nasm -f win32 %filename%.asm
link harness.obj %filename%.obj kernel32.lib /entry:main /out:%filename%.exe
