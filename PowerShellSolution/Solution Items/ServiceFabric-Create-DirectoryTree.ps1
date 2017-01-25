param(
[string]$appname,
[string] $root
)

function Create-Directory 
{
	$dir = $args[0]
	if( $dir -eq $null -Or $dir -eq "" ){
		Write-Host "Missing directory parameter"
		return
	}
	
	if( Test-Path -Path $dir ){
		$res = Read-Host -Prompt ("Directory .\{0} exists.  Do you want to overwrite (Y/N)?" -f $dir)
		if( $res -ne 'Y' )
		{
			return
		}

		return New-Item -Path $dir -ItemType "directory" -force
	}
	
	return New-Item -Path $dir -ItemType "directory"
}

function Create-ServiceManifest
{
	$contents = @"test"@
	$path = $args[0]

	if( $path -eq $null -Or $path -eq "" ){
		Write-Host "Missing path parameter"
		return
	}

	$contents | Out-File -FilePath $path -Encoding ascii
}

if( $appname -eq $null -Or $appname -eq "" ){
	Write-Host "Missing appname parameter"
	exit
}

#if a root was specified, change to that working directory
if( $root -ne $null -and $root -ne "" -and (Test-Path -Path $root))
{
	Set-Location -Path $root
}


$dir = Create-Directory ($appname + "PackageRoot")
if( $dir -eq $null )
{
	exit
}

Push-Location 

Set-Location -Path $dir
New-Item -Path . -Name "ApplicationManifest.xml" -ItemType "file" -Force

$dir = Create-Directory ($appname + "Package")
if( $dir -eq $null )
{
	exit
}
Set-Location -Path $dir

Create-Directory "Code"
Create-Directory "Config"
Create-Directory "Data"
New-Item -Path . -Name "ServiceManifest.xml" -ItemType "file" -Force

Pop-Location






