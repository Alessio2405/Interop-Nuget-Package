@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ——— Parametri & Default ———
set "PackageVersion=2.0.0"
if not "%~1"=="" set "PackageVersion=%~1"

set "OutputPath=.\packages"
if not "%~2"=="" set "OutputPath=%~2"

:: ——— Rileva o imposta il .nuspec ———
set "NuspecFile="
if not "%~3"=="" (
    set "NuspecFile=%~3"
) else (
    for /f "delims=" %%F in ('dir /b *.nuspec 2^>nul') do (
        set "NuspecFile=%%F"
        goto :foundNuspec
    )
)

:foundNuspec
if not defined NuspecFile (
    echo [ERROR] No .nuspec file found here.
    exit /b 1
)

:: ——— Verifica NuGet CLI ———
where nuget >nul 2>&1
if errorlevel 1 (
    echo [ERROR] NuGet CLI not found in PATH.
    exit /b 1
)

:: ——— Verifica file necessari ———
if not exist "%NuspecFile%" (
    echo [ERROR] File .nuspec not found: "%NuspecFile%".
    exit /b 1
)
if not exist "your_dll_interop.dll" (
    echo [ERROR] your_dll_interop.dll not found in current folder.
    exit /b 1
)
if not exist "your_dll_interop.props" (
    echo [ERROR] your_dll_interop.props not found in current folder.
    exit /b 1
)
if not exist "your_dll_interop.targets" (
    echo [ERROR] your_dll_interop.targets not found in current folder.
    exit /b 1
)

:: ——— Dicrectory creation ———
md build           2>nul
md lib\net8.0      2>nul
md ref\net8.0      2>nul
md "%OutputPath%"  2>nul

:: ——— Copying files ———
copy /Y "your_dll_interop.dll"              "lib\net8.0\"     >nul
copy /Y "your_dll_interop.dll"              "ref\net8.0\"     >nul
copy /Y "your_dll_interop.props"    "build\"         >nul
copy /Y "your_dll_interop.targets"  "build\"         >nul

:: ——— Package Build ———
echo.
echo ===== Build NuGet package =====
echo .nuspec used: %NuspecFile%
nuget pack "%NuspecFile%" -Version %PackageVersion% -OutputDirectory "%OutputPath%" -Verbosity detailed
if errorlevel 1 (
    echo [ERROR] Creation failed (exit code %errorlevel%).
    goto :cleanup
) else (
    echo [OK] Package succesfully created!
)

:: ——— Print folder output ———
echo.
echo Contenuto di "%OutputPath%":
dir "%OutputPath%\*.nupkg"

:cleanup
:: ——— Cleanup ———
echo.
echo Pulizia directory temporanee...
rmdir /S /Q build   2>nul
rmdir /S /Q lib     2>nul
rmdir /S /Q ref     2>nul


echo.
echo DONE 🎉
exit /b %errorlevel%
