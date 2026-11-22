# Build everything and regenerate the saved outputs in results/.
# elan picks Lean v4.15.0 from lean-toolchain.
# Usage (PowerShell, in the repository root):  .\run_all.ps1
Set-Location $PSScriptRoot

# Use the default elan location if lake is not on PATH in this shell.
if (-not (Get-Command lake -ErrorAction SilentlyContinue)) {
    $env:PATH = "$env:USERPROFILE\.elan\bin;$env:PATH"
}

lake build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# The executables write their CSV files to the current directory, so run them from results/.
# Output is redirected by cmd, not PowerShell, so the bytes are saved unchanged
# (no BOM, LF line endings) and match the Linux reference outputs exactly.
$bin = Join-Path $PSScriptRoot ".lake\build\bin"
New-Item -ItemType Directory -Force results | Out-Null
Push-Location results
try {
    foreach ($exe in "report", "climate", "argII", "argIII", "experimentE", "friction") {
        cmd /c "`"$bin\$exe.exe`" > ${exe}_output.txt"
        if ($LASTEXITCODE -ne 0) { Write-Error "$exe failed with exit code $LASTEXITCODE"; exit $LASTEXITCODE }
    }
} finally {
    Pop-Location
}
Write-Host "Done. Outputs are in results/ (*_output.txt and *.csv)."
