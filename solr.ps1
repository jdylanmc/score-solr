Param (
	[Parameter(Mandatory=$false)]
	[bool]$full = $true
)

$sandboxRoot = "sandbox\Website"
$includeFolder = "$sandboxRoot\App_Config\Include\"
$bin = "sandbox\Website\bin"

$solrConfigFiles = @();
$luceneConfigFiles = @();

# to be more surgical, we could try just enabling Sitecore.ContentSearch.Solr.DefaultIndexConfiguration.config,
# and create custom indexes in SOLR directly while leaving the rest of sitecore in lucene
if ($full) {
	$solrConfigFiles += Get-ChildItem "$includeFolder" -recurse | ?{ -not $_.PSIsContainer } | Where-Object { $_.Name -match "solr" -and $_.Name -ne "Sitecore.ContentSearch.SolrCloud.SwitchOnRebuild.config.example" }
	$luceneConfigFiles += Get-ChildItem "$includeFolder" -recurse | ?{ -not $_.PSIsContainer } | Where-Object { $_.Name -match "lucene" -or $_.Name -match "zzScore.ContentSearch.sitecore_web_index.config" -or $_.Name -match "zzScore.ContentSearch.sitecore_master_index.config" }
}
else {
	$solrConfigFiles = Get-ChildItem "$includeFolder" -recurse | ?{ -not $_.PSIsContainer } | Where-Object { $_.Name -match "Sitecore.ContentSearch.Solr.DefaultIndexConfiguration.config" }
}

foreach ($file in $solrConfigFiles) {
	$extension = [IO.Path]::GetExtension($file)
	if ($extension -ne "config") {
		$fileName = $file.FullName.Substring(0, $file.FullName.LastIndexOf('.'))
		Move-Item "$fileName.*" "$fileName"
	}
}

foreach ($file in $luceneConfigFiles) {
	if (-not ($file -match "disable")) {
	 	Move-Item $file.FullName "$($file.FullName).disable"
	}
}

if ($full) {
	# copy solr .dll's and config into running sitecore instance
	Get-ChildItem -Path "Libs\Solr\Full" | ForEach-Object {
		Copy-Item $_.FullName -Destination $sandboxRoot -recurse -Force
	}
}
else {
	# copy solr .dll's and config into running sitecore instance
	Get-ChildItem -Path "Libs\Solr\Partial" | ForEach-Object {
		Copy-Item $_.FullName -Destination $sandboxRoot -recurse -Force
	}	
}
