# Installe ou met a jour le kit agent dans le projet courant (a lancer depuis la racine du depot git du projet).
#   Derniere version : irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
#   Version precise  : $env:AGENT_KIT_VERSION = "v1.0.0"; irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
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

    $root = (Get-Location).ProviderPath
    $top = Invoke-Git @('rev-parse', '--show-toplevel')
    if ($top.Code -ne 0 -or -not $top.Out) {
        throw "le dossier courant n'est pas dans un depot git. Lancer le script depuis la racine du projet."
    }
    $topFull = [IO.Path]::GetFullPath($top.Out[0]).TrimEnd('\', '/')
    if ($topFull -ne $root.TrimEnd('\', '/')) {
        throw "lancer le script depuis la racine du depot ($topFull), pas depuis un sous-dossier."
    }

    if (Test-Path 'agent/project') {
        throw 'agent/project/ existe (ancienne installation). Deplacer son contenu vers agent-project/, supprimer agent/project/, puis relancer.'
    }
    if ((Test-Path 'agent') -and -not (Test-Path 'agent/AGENT.md')) {
        throw "agent/ existe mais ne contient pas AGENT.md : ce n'est pas le kit, installation annulee."
    }
    if (Test-Path 'agent') {
        if ((Invoke-Git @('status', '--porcelain', '--', 'agent')).Out) { Write-Warning 'agent/ contient des modifications locales non commitees : elles vont etre ecrasees.' }
    }

    if (-not $Version) {
        # Derniere version stable : les pre-versions (tags contenant '-', ex : v1.1.0-rc1) sont ignorees.
        $refs = Invoke-Git @('ls-remote', '--tags', '--refs', '--sort=-v:refname', $KitUrl, 'refs/tags/v*')
        if ($refs.Code -ne 0) { throw "impossible de lister les versions de $KitUrl. $($refs.Err)" }
        $stable = @($refs.Out | ForEach-Object { $_ -replace '.*refs/tags/', '' } | Where-Object { $_ -and $_ -notmatch '-' })
        if ($stable.Count -eq 0) { throw "aucune version publiee trouvee sur $KitUrl." }
        $Version = $stable[0]
    }

    $tmp = Join-Path ([IO.Path]::GetTempPath()) ('agent-kit-' + [guid]::NewGuid())
    $staging = Join-Path $root 'agent.new'
    try {
        $clone = Invoke-Git @('-c', 'advice.detachedHead=false', 'clone', '--quiet', '--depth', '1', '--branch', $Version, '-c', 'core.autocrlf=false', $KitUrl, "$tmp/src")
        if ($clone.Code -ne 0) { throw "impossible de recuperer la version $Version depuis $KitUrl. $($clone.Err)" }
        if (-not (Test-Path "$tmp/src/kit/AGENT.md")) { throw "la version $Version ne contient pas kit/AGENT.md." }
        $sha = (Invoke-Git @('-C', "$tmp/src", 'rev-parse', 'HEAD')).Out[0].Trim()

        $previous = ''
        if (Test-Path 'agent/VERSION') { $previous = (Get-Content 'agent/VERSION' -TotalCount 1).Trim() }

        # Remplacement atomique : le nouveau kit est prepare dans agent.new/ avant de toucher a agent/.
        if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
        Copy-Item "$tmp/src/kit" $staging -Recurse
        [IO.File]::WriteAllText((Join-Path $staging 'VERSION'), "$Version`n$sha`n")
        if (Test-Path 'agent') { Remove-Item 'agent' -Recurse -Force }
        Rename-Item $staging 'agent'

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
        if (Test-Path $staging) { Remove-Item $staging -Recurse -Force -ErrorAction SilentlyContinue }
        if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
    }

    if ($previous) {
        Write-Host "Kit agent mis a jour : $previous -> $Version ($sha)"
        Write-Host "A faire : relire le CHANGELOG, commiter agent/. L'agent signale au demarrage les identifiants de agent-project/rules.md inconnus du kit."
    }
    else {
        Write-Host "Kit agent $Version installe dans agent/ ($sha)"
        Write-Host "A faire : commiter agent/ et agent-project/, puis lancer la commande 'init' dans l'IDE."
    }
}

function Invoke-Git([string[]]$GitArgs) {
    # Windows PowerShell 5.1 hors console (CI, sortie redirigee) transforme le stderr de git en
    # erreur, fatale avec ErrorActionPreference=Stop. Continue dans cette portee seulement.
    $ErrorActionPreference = 'Continue'
    $all = @(& git @GitArgs 2>&1)
    $code = $LASTEXITCODE
    [pscustomobject]@{
        Code = $code
        Out  = @($all | Where-Object { $_ -isnot [Management.Automation.ErrorRecord] } | ForEach-Object { "$_" })
        Err  = (@($all | Where-Object { $_ -is [Management.Automation.ErrorRecord] } | ForEach-Object { "$_" }) -join ' ')
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
