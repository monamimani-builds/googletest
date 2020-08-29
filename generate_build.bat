echo on

SET VSWHERE_PATH="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"

for /f "usebackq tokens=*" %%i in (`%VSWHERE_PATH% -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set InstallDir=%%i
)

if not exist "%InstallDir%\Common7\Tools\vsdevcmd.bat" (
  exit /b 2
)

//call "$(VcvarsallPath)\VC\Auxiliary\Build\vcvarsall.bat" x64
call "%InstallDir%\VC\Auxiliary\Build\vcvarsall.bat" x64
cmake.exe -S googletest -Wno-dev -B _build -D CMAKE_INSTALL_PREFIX=_install -D CMAKE_BUILD_TYPE=Debug;RelWithDebInfo -D CMAKE_CXX_COMPILER="cl.exe" -D CMAKE_C_COMPILER="cl.exe" -D MSVC_TOOLSET_VERSION=142 -D BUILD_GMOCK=TRUE -D BUILD_SHARED_LIBS=TRUE -D INSTALL_GTEST=TRUE -G "Ninja"

cmake --build ./_build --target install