@echo off
echo Cleaning up temporary test projects...

REM Wait a moment for any file handles to release
timeout /t 3 /nobreak > nul 2>&1

REM Remove temporary directories
if exist "temp_mult_test" (
    echo Removing temp_mult_test...
    rmdir /s /q "temp_mult_test" 2>nul
    if exist "temp_mult_test" (
        echo Warning: Could not fully remove temp_mult_test
    ) else (
        echo temp_mult_test removed successfully
    )
)

if exist "temp_rca_test" (
    echo Removing temp_rca_test...
    rmdir /s /q "temp_rca_test" 2>nul
    if exist "temp_rca_test" (
        echo Warning: Could not fully remove temp_rca_test
    ) else (
        echo temp_rca_test removed successfully
    )
)

if exist "temp_cla_test" (
    echo Removing temp_cla_test...
    rmdir /s /q "temp_cla_test" 2>nul
    if exist "temp_cla_test" (
        echo Warning: Could not fully remove temp_cla_test
    ) else (
        echo temp_cla_test removed successfully
    )
)

if exist "temp_random_test" (
    echo Removing temp_random_test...
    rmdir /s /q "temp_random_test" 2>nul
    if exist "temp_random_test" (
        echo Warning: Could not fully remove temp_random_test
    ) else (
        echo temp_random_test removed successfully
    )
)

echo Cleanup completed!
pause
