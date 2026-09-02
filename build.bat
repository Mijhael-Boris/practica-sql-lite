@echo off
echo ========================================
echo FORZANDO JAVA 17 PARA COMPILAR
echo ========================================
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot
set PATH=%JAVA_HOME%\bin;%PATH%
echo Usando Java:
java -version
echo.
echo ========================================
echo LIMPIANDO PROYECTO
echo ========================================
flutter clean
echo.
echo ========================================
echo OBTENIENDO DEPENDENCIAS
echo ========================================
flutter pub get
echo.
echo ========================================
echo COMPILANDO APK
echo ========================================
flutter build apk --split-per-abi
pause