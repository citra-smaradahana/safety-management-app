@echo off
echo ========================================
echo Deployment Script - Safety Management App
echo ========================================

echo.
echo 1. Building application...
call npm run build

if %errorlevel% neq 0 (
    echo Build failed! Please check the errors above.
    pause
    exit /b 1
)

echo.
echo 2. Build completed successfully!
echo Build files are in the 'dist' folder.

echo.
echo 3. Choose deployment option:
echo [1] Vercel
echo [2] Netlify (manual upload)
echo [3] GitHub Pages
echo [4] Firebase Hosting
echo [5] Just build (no deploy)

set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto vercel
if "%choice%"=="2" goto netlify
if "%choice%"=="3" goto github
if "%choice%"=="4" goto firebase
if "%choice%"=="5" goto end

echo Invalid choice!
goto end

:vercel
echo.
echo Deploying to Vercel...
echo Please make sure you have Vercel CLI installed: npm install -g vercel
echo.
vercel --prod dist
goto end

:netlify
echo.
echo For Netlify deployment:
echo 1. Go to https://netlify.com
echo 2. Drag and drop the 'dist' folder to deploy
echo 3. Or connect your GitHub repository for auto-deploy
echo.
goto end

:github
echo.
echo For GitHub Pages deployment:
echo 1. Push your code to GitHub first
echo 2. Go to repository Settings > Pages
echo 3. Set source to 'Deploy from a branch'
echo 4. Select 'main' branch and '/' folder
echo 5. Click Save
echo.
goto end

:firebase
echo.
echo Deploying to Firebase...
echo Please make sure you have Firebase CLI installed: npm install -g firebase-tools
echo.
firebase deploy
goto end

:end
echo.
echo ========================================
echo Deployment script completed!
echo ========================================
pause 