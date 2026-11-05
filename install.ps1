# Installe ou met a jour le kit agent dans le projet courant (a lancer depuis la racine du projet).
#   Derniere version : irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
#   Version precise  : $env:AGENT_KIT_VERSION = "v1.3.0"; irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
# Variables optionnelles : AGENT_KIT_VERSION (version), AGENT_KIT_URL (depot git du kit, ex : un fork).
# Fichier en ASCII : Windows PowerShell 5.1 lit les .ps1 sans BOM comme ANSI.
param(
    [string]$Version = $env:AGENT_KIT_VERSION,
    [string]$KitUrl = $env:AGENT_KIT_URL
)

function Install-AgentKit([string]$Version, [string]$KitUrl) {
    $ErrorActionPreference = 'Stop'
    if (-not $KitUrl) { $KitUrl = 'https://github.com/Wahki-Dev/Alfred.git' }

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'git est requis.' }
    if (Test-Path 'agent/project') {
        throw 'agent/project/ existe (ancienne installation). Deplacer son contenu vers agent-project/, supprimer agent/project/, puis relancer.'
    }
    if ((Test-Path 'agent') -and -not (Test-Path 'agent/AGENT.md')) {
        throw "agent/ existe mais ne contient pas AGENT.md : ce n'est pas le kit, installation annulee."
    }

    if (-not $Version) {
        $refs = @(git ls-remote --tags --refs --sort=-v:refname $KitUrl 'refs/tags/v*')
        if ($LASTEXITCODE -ne 0 -or $refs.Count -eq 0) { throw "aucune version publiee trouvee sur $KitUrl." }
        $Version = $refs[0] -replace '.*refs/tags/', ''
    }

    $root = (Get-Location).ProviderPath
    $tmp = Join-Path ([IO.Path]::GetTempPath()) ('agent-kit-' + [guid]::NewGuid())
    try {
        git -c advice.detachedHead=false clone --quiet --depth 1 --branch $Version -c core.autocrlf=false $KitUrl "$tmp/src"
        if ($LASTEXITCODE -ne 0) { throw "impossible de recuperer la version $Version depuis $KitUrl." }
        if (-not (Test-Path "$tmp/src/kit/AGENT.md")) { throw "la version $Version ne contient pas kit/AGENT.md." }

        $previous = ''
        if (Test-Path 'agent/VERSION') { $previous = (Get-Content 'agent/VERSION' -Raw).Trim() }

        if (Test-Path 'agent') { Remove-Item 'agent' -Recurse -Force }
        Copy-Item "$tmp/src/kit" 'agent' -Recurse
        [IO.File]::WriteAllText((Join-Path $root 'agent/VERSION'), "$Version`n")

        Copy-Missing "$tmp/src/agent-project-template" (Join-Path $root 'agent-project')
        Copy-Missing "$tmp/src/bootstrap" $root

        $bootstrap = (Get-Item "$tmp/src/bootstrap").FullName
        Get-ChildItem $bootstrap -Recurse -File -Force | ForEach-Object {
            $rel = $_.FullName.Substring($bootstrap.Length).TrimStart('\', '/')
            if (-not (Select-String -Path (Join-Path $root $rel) -SimpleMatch 'agent/AGENT.md' -Quiet)) {
                Write-Warning "$rel existe deja sans reference a agent/AGENT.md, ajouter l'instruction a la main (voir agent/README.md)."
            }
        }
    }
    finally {
        if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
    }

    if ($previous) {
        Write-Host "Kit agent mis a jour : $previous -> $Version"
        Write-Host "A faire : commiter agent/, puis lancer la commande 'regen check' dans l'IDE."
    }
    else {
        Write-Host "Kit agent $Version installe dans agent/"
        Write-Host "A faire : commiter agent/ et agent-project/, puis lancer la commande 'init' dans l'IDE."
    }
}

function Copy-Missing([string]$Source, [string]$Destination) {
    $Source = (Get-Item $Source).FullName
    Get-ChildItem $Source -Recurse -File -Force | ForEach-Object {
        $rel = $_.FullName.Substring($Source.Length).TrimStart('\', '/')
        $target = Join-Path $Destination $rel
        if (-not (Test-Path $target)) {
            New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
            Copy-Item $_.FullName $target
            Write-Host "  cree : $target"
        }
    }
}

Install-AgentKit -Version $Version -KitUrl $KitUrl
