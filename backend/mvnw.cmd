@echo off
where mvn >nul 2>nul
if errorlevel 1 (
  echo Maven 3.9+ no esta instalado. Use: docker build . 1>&2
  exit /b 127
)
mvn %*

