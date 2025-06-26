@echo off
echo =========================================
echo   Command Line Controlled Verification
echo         Environment (CL-CVE)
echo =========================================
echo.
echo Running comprehensive verification of all DUTs...
echo.

vivado -mode batch -source run_all_tests.tcl

echo.
echo =========================================
echo   Verification complete!
echo =========================================
pause
