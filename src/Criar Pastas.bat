@echo off
chcp 65001 > nul
if "%~1" neq "" cd /d "%~1"

md "--00000.000000.0000-00--XXXX--DSEI--LOCAL"
md "--00000.000000.0000-00--XXXX--DSEI--LOCAL\Arquitetura"
md "--00000.000000.0000-00--XXXX--DSEI--LOCAL\Arquivos Recebidos"
md "--00000.000000.0000-00--XXXX--DSEI--LOCAL\Instalações Elétricas"
md "--00000.000000.0000-00--XXXX--DSEI--LOCAL\Arquivos enviados (PDF)"
md "--00000.000000.0000-00--XXXX--DSEI--LOCAL\SPDA"
md "--00000.000000.0000-00--XXXX--DSEI--LOCAL\REF"

:: Atualiza as janelas do Windows Explorer para exibir a nova pasta imediatamente
powershell -NoProfile -Command "$s = New-Object -ComObject Shell.Application; foreach ($w in $s.Windows()) { try { $w.Refresh() } catch {} }" > nul 2>&1
