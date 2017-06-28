
1. Set up SOLR accordingly.
2. Copy the contents of this repository (excluding the src directory) as a sibling to your 'sandbox' installation directory.
3. Open powershell and navigate to the /cores directory
4. Run reinstall.ps1 to install all SOLR cores
5. Turn off your Sitecore website in IIS
6. Run the solr.ps1 to convert Sitecore over to use SOLR
7. Find App_Config/Include/_TENANT.ContentSearch.Index.ScoreSolrConfiguration.config.example and:
   * Rename this file to align with your tenant name
   * Open this file and replace 'TENANT-SITE-NAME' with the name of your tenant according to your site definition.  Additionally, add any custom tiles as necessary.
   * Move this file to your tenant's configuration folder appropriately.  Additionally, you should include this file in your tenant's Environment configuration project.   
8. Turn your Sitecore website back on in IIS
9. Navigate to your control panel and instruct Sitecore to rebuild indexes.

NOTE: It should be possible to create a new index configuration on a per-tenant basis.  If you do this, be sure you
call out the 'contentSearch/indexConfigurations/scoreSolrConfiguration' instead of 'contentSearch/indexConfigurations/defaultSolrIndexConfiguration'