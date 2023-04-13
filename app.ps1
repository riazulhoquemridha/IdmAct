# Enable TLSv1.2 for compatibility with older clients
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://raw.githubusercontent.com/riazulhoquemridha/IdmAct/main/IAS_0.7_ModByPiash.cmd'

try {
    $response = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing
}
catch {
    "Error"
}

$rand = Get-Random -Maximum 1000
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = "$env:SystemRoot\Temp\IdmAct_$rand.cmd"
Set-Content -Path $FilePath -Value $response

# Set a custom name for IDM license info
$getName = Read-Host -Prompt "Set a name for the license"
if ([string]::IsNullOrWhiteSpace($getName)) {
    $getName = $env:USERNAME
}

$insertCode = "set name=$getName"
$content = Get-Content $FilePath
$content[6] += "`r`n" + $insertCode

$content | Out-File $FilePath -Encoding ASCII

if (Test-Path $FilePath) {
    Start-Process $FilePath -Wait
    $item = Get-Item -LiteralPath $FilePath
    $item.Delete()
}
