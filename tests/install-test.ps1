# Test d'integration de install.ps1 (execute comme irm | iex) contre un depot de kit local.
# Usage : powershell -File tests/install-test.ps1   (ou pwsh)
# Fichier en ASCII (Windows PowerShell 5.1).
$ErrorActionPreference = 'Stop'

$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).ProviderPath
$installer = Join-Path $repo 'install.ps1'
$work = Join-Path ([IO.Path]::GetTempPath()) ('agent-kit-test-' + [guid]::NewGuid())
New-Item -ItemType Directory $work | Out-Null

function G {
    # stderr de git (avertissements CRLF...) : non fatal hors console sous 5.1, seul le code retour compte.
    $ErrorActionPreference = 'Continue'
    & git -c user.name=ci -c user.email=ci@example.invalid -c init.defaultBranch=main -c core.autocrlf=false @args 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "git $args" }
}
function Fail([string]$Message) { throw "ECHEC : $Message" }
function Ok([string]$Message) { Write-Host "ok - $Message" }
function Invoke-Installer {
    # Comme un utilisateur : contenu du script passe a Invoke-Expression.
    $code = Get-Content -Raw $installer
    try { Invoke-Expression $code *> $null; return $true } catch { return $false }
}

$origin = Get-Location
try {
    # Depot de kit local : v1.0.0 (stable) puis v1.1.0-rc1 (pre-version, ne doit pas etre choisie).
    $kit = Join-Path $work 'kit-repo'
    New-Item -ItemType Directory $kit | Out-Null
    Get-ChildItem $repo -Force | Where-Object { $_.Name -ne '.git' } | Copy-Item -Destination $kit -Recurse
    Set-Location $kit
    G init -q
    G add -A
    G commit -qm kit
    G tag v1.0.0
    Set-Content -Path rc.txt -Value 'rc'
    G add rc.txt
    G commit -qm rc
    G tag v1.1.0-rc1

    $env:AGENT_KIT_URL = $kit
    $env:AGENT_KIT_VERSION = ''

    $app = Join-Path $work 'app'
    New-Item -ItemType Directory $app | Out-Null
    Set-Location $app
    G init -q

    # 1) Installation fraiche.
    if (-not (Invoke-Installer)) { Fail 'installation fraiche' }
    if (-not (Test-Path 'agent/AGENT.md')) { Fail 'agent/AGENT.md absent' }
    $lines = @(Get-Content 'agent/VERSION')
    if ($lines[0] -ne 'v1.0.0') { Fail "VERSION ligne 1 : attendu v1.0.0, obtenu $($lines[0])" }
    if ($lines[1] -notmatch '^[0-9a-f]{40}$') { Fail 'VERSION ligne 2 : SHA attendu' }
    if (Test-Path 'agent.new') { Fail 'agent.new laisse en place' }
    foreach ($f in 'agent-project/rules.md', 'CLAUDE.md', 'AGENTS.md', '.cursor/rules/global.mdc', '.github/copilot-instructions.md') {
        if (-not (Test-Path $f)) { Fail "$f absent apres installation" }
    }
    Ok 'installation fraiche (v1.0.0, pre-version ignoree)'

    # 2) Mise a jour : agent-project/ preserve.
    Set-Content -Path 'agent-project/memory.md' -Value 'memoire modifiee'
    G add -A
    G commit -qm app
    if (-not (Invoke-Installer)) { Fail 'mise a jour' }
    if ((Get-Content 'agent-project/memory.md' -Raw).Trim() -ne 'memoire modifiee') { Fail 'agent-project/memory.md ecrase' }
    Ok 'mise a jour : agent-project/ preserve'

    # 3) Refus si agent/project/ existe.
    New-Item -ItemType Directory 'agent/project' | Out-Null
    if (Invoke-Installer) { Fail 'aurait du refuser agent/project/' }
    Remove-Item 'agent/project'
    Ok 'refus si agent/project/ existe'

    # 4) Refus dans un sous-dossier.
    New-Item -ItemType Directory 'sub' | Out-Null
    Set-Location 'sub'
    if (Invoke-Installer) { Fail 'aurait du refuser un sous-dossier' }
    if (Test-Path 'agent') { Fail 'installation creee dans le sous-dossier' }
    Set-Location $app
    Ok 'refus dans un sous-dossier'

    # 5) Refus hors depot git.
    $nogit = Join-Path $work 'nogit'
    New-Item -ItemType Directory $nogit | Out-Null
    Set-Location $nogit
    if (Invoke-Installer) { Fail 'aurait du refuser hors depot git' }
    if (Test-Path 'agent') { Fail 'installation creee hors depot git' }
    Ok 'refus hors depot git'

    Write-Host 'install-test.ps1 : OK'
}
finally {
    Set-Location $origin
    Remove-Item Env:AGENT_KIT_URL -ErrorAction SilentlyContinue
    Remove-Item Env:AGENT_KIT_VERSION -ErrorAction SilentlyContinue
    Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
}
