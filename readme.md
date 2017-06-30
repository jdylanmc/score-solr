# SOLR + SCORE
This repository is meant to act as a starting point for configuring your SCORE 2.5.x installation for usage with SOLR.  As of writing, this has been validated as working with: 
* Sitecore 8.2 update 1
* SOLR 6.1.x
* SCORE 2.5.x

## Local environment setup instructions

1. Set up SOLR accordingly.  See the SOLR Setup section below for more information.  Take note that the scripts contained here assume a particular version of SOLR installed in a specific path.  This can be changed, but you may need to intervene on the automated scripts to accomodate.
2. Copy the contents of this repository (excluding the src directory) as a sibling to your 'sandbox' installation directory.  If you chose to move this directory, or are installing on a server, you may need to make modifications to the pathing variables in the `solr.ps1` file accordingly.
3. Turn off your Sitecore website in IIS.  If you try and configure SOLR with Sitecore running, it may lead to inconsistent results.
4. Open powershell and navigate to the `/cores` directory which you have copied as a sibling of your sandbox directory.
5. Run `reinstall.ps1` to install all SOLR cores.  
   * Note: From powershell, you may need to set your execution policy to remote signed.  If you need to, run this powershell command as an administrator on your machine: `Set-ExecutionPolicy -RemoteSigned`.  See [this documentation](https://technet.microsoft.com/en-us/library/ee176961.aspx) for more information.
6. Run the `solr.ps1` script to convert Sitecore over to use SOLR.
   * This script assumes that it can locate a `sandbox` directory which has Sitecore installed inside.  If that is not the case, please update the paths within the `solr.ps1` file accordingly.
   * This script has an optional parameter for installing in "partial" mode (e.g., leave Sitecore indexes in Lucene and convert site tenant indexes to SOLR).  While this is technically possible, it has not been tested.  I've left example configuration under the libs folder which you may use to attempt this if you wish.
7. Find App_Config/Include/_TENANT.ContentSearch.Index.ScoreSolrConfiguration.config.example in your Sitecore installation and:
   * Rename this file to align with your tenant name.
   * Open this file and replace 'TENANT-SITE-NAME' with the name of your tenant according to your site definition.  Additionally, add any custom tiles as necessary.
   * Move this file to your tenant's configuration folder appropriately.  Additionally, you should include this file in your tenant's Environment configuration project.  This file should replace the existing tile configurations that came pre-scaffolded with your SCORE tenant.
8. Turn your Sitecore website back on in IIS
9. Navigate to your control panel and instruct Sitecore to rebuild indexes.

## SOLR Setup

1. [Install JRE](http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html) if you don't already have it.
2. Add a system environment variable called JAVA_HOME that points to your java installation:
    * Variable Name: JAVA_HOME
    * Variable Value (set as necessary): C:\Program Files (x86)\Java\jre1.8.0_77
3. [Install NSSM](https://nssm.cc/) at `C:/nssm` (or the directory of your choice).
4. Create and unzip [SOLR 6.1.0](http://archive.apache.org/dist/lucene/solr/) into C:/solr
    * NOTE: Remove any intermediary folders to avoid a folder structure like `C:/solr/solr-6.1.0/server`
    * This should now be a valid path on your file system: `C:/solr/server`
    * Keep in mind that if you do not install SOLR to this directory, then some automation scripts may require manual intervention and/or passing your solr installation directory as an argument.
    * While the instructions here mention SOLR 6.1.0, this will likely work with other versions as well.  As of writing, 6.1.0 is the version of SOLR which I have used to validate this setup.
5. Open Powershell and use NSSM to set SOLR up as a service as follows:
    ```powershell
    # Use either 64 or 32 bit version according to your computer
    cd C:\nssm\win64
    ./nssm install SOLR
    ```
6. The NSSM Service Installer application window will open.  Set the following values:
    * Path: C:\solr\bin\solr.cmd
    * Startup Directory: C:\solr\bin
    * Arguments: start -f -p 8983
    * Display Name: SOLR 6.1.0
    * Description: C:\solr\bin\solr.cmd start -f -p 8983
    * Startup type: Automatic
7. Open your services and start the newly created SOLR 6.1.0 service.
    * Verify that you can see the SOLR Dashboard at http://localhost:8983/solr/#/
    * Verify that after a reboot SOLR starts correctly and you can still see http://localhost:8983/solr/#/
