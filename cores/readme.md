# SOLR Core Installation

This directory contains SOLR Cores pre-configured for Sitecore 8.2. To install these cores, use the `reinstall.ps1` script.  Additionally, if you want to create a new core, you can use the `example-core` directory as a starting place.  If you want to create a core per tenant, then you can rename and re-use the `TENANT_INDEX_NAME` cores.

## Full Installation of SOLR
The full installation of SOLR refers to the notion of converting the entire Sitecore installation to use SOLR.  To install cores in this manner, execute the following reinstallation script from a powershell terminal:

`./reinstall.ps1`

This script assumes that you have installed SOLR under `C:\solr`.  If you have installed SOLR in a different location (or under a different port), you can specify those attributes via running the script like so:

`./reinstall.ps1 -solrPath "C:\path\to\solr" -solrPort 8585`

## Partial Installation of SOLR
The partial installation of SOLR refers to the notion of introducing SOLR only to your tenant websites and leaving the default Sitecore indexes in lucene.  To perform a partial installation, follow these steps:

1. Rename or copy the `TENANT_INDEX_NAME_master` core to a logical name for your tenant.
2. Rename or copy the `TENANT_INDEX_NAME_web` core to a logical name for your tenant.
3. Run the `reinstall.ps1` script from a powershell terminal and manually specify which cores to reinstall (one at a time):

`./reinstall.ps1 -core "TENANT_INDEX_NAME_master"`

`./reinstall.ps1 -core "TENANT_INDEX_NAME_web"`

Additionally, if SOLR is installed in a different location or running on a different port, you can execute the script like so:

`./reinstall.ps1 -solrPath "C:\path\to\solr" -solrPort 8587 -core "TENANT_INDEX_NAME_master"`

