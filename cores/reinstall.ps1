Param (
	[Parameter(Mandatory=$false)]
	[string]$solrPath="C:\solr",
	
	[Parameter(Mandatory=$false)]
	[int]$solrPort,
	
	[Parameter(Mandatory=$false)]
	[string]$core
)

$cores = @();

if ($core) {
	$cores = Get-ChildItem -Path ".\" | ?{ $_.PSIsContainer } | Where-Object { $_.Name -eq $core }
} else {
	$cores = Get-ChildItem -Path ".\" | ?{ $_.PSIsContainer } | Where-Object { $_.Name -ne 'example-core' -and $_.Name -ne 'TENANT_INDEX_NAME_master' -and $_.Name -ne 'TENANT_INDEX_NAME_web' }
}

# Install SOLR cores
$cores | ForEach-Object {
	$destination = "$solrPath\server\solr"
	if (!(Test-Path "$destination\$_")) {
		Write-Host "Installing SOLR Core: $_"
		Copy-Item $_.FullName "$solrPath\server\solr" -recurse
		if (-Not $solrPort) {
			cmd.exe /c "$solrPath\bin\solr.cmd create -c $_"
		}
		else {
			cmd.exe /c "$solrPath\bin\solr.cmd create -c $_ -port $solrPort"
		}
	} else {
		Write-Host "SOLR Core: $_ already exists" -foreground "yellow"
		Write-Host "Uninstalling SOLR Core: $_"
		if (-Not $solrPort) {
			cmd.exe /c "$solrPath\bin\solr.cmd delete -c $_"
		}
		else {
			cmd.exe /c "$solrPath\bin\solr.cmd delete -c $_ -port $solrPort"
		}
		
		Start-Sleep -s 3
			
		if (Test-Path "$destination\$_") {
			Write-Host "Cleaning up $destination\$_"
			Remove-Item "$destination\$_" -recurse
		}
		
		Write-Host "Re-installing SOLR Core: $_"
		Copy-Item $_.FullName "$solrPath\server\solr" -recurse
		if (-Not $solrPort) {
			cmd.exe /c "$solrPath\bin\solr.cmd create -c $_"
		}
		else {
			cmd.exe /c "$solrPath\bin\solr.cmd create -c $_ -port $solrPort"
		}
	}
}