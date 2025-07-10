@echo off
REM Quick Test Batch File for testing all designs sequentially
echo ========================================
echo   Command Line Controlled Verification
echo         Environment (CL-CVE)
echo ========================================
echo Running quick test for all designs...
echo.

REM Test RCA Adder
echo ---- TESTING RCA ADDER ----
vivado -mode batch -source scripts\run_rca.tcl
if %ERRORLEVEL% NEQ 0 (
    echo Error testing RCA Adder!
    exit /b 1
)

REM Test CLA Adder
echo.
echo ---- TESTING CLA ADDER ----
vivado -mode batch -source scripts\run_cla.tcl
if %ERRORLEVEL% NEQ 0 (
    echo Error testing CLA Adder!
    exit /b 1
)

REM Test Multiplier
echo.
echo ---- TESTING MULTIPLIER ----
vivado -mode batch -source scripts\run_mult.tcl
if %ERRORLEVEL% NEQ 0 (
    echo Error testing Multiplier!
    exit /b 1
)

echo.
echo ========================================
echo All tests completed successfully!
echo ========================================
pause
