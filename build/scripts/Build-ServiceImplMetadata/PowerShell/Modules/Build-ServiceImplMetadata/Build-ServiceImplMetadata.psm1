function Build-ServiceImplMetadata {

    <#
    .SYNOPSIS
        Creates service implementation classes and custom metadata that can be deployed using ANT.

        Note: This will not create the implementation field on the SObject nor assign permissions for that field. Please
        create manually if not already created.

        Also, this also creates all the fflib classes and custom metadata as well, so please verify you are not
        deploying over existing metadata. If you do not need those classes or metadata they can be removed the from
        classes and customMetadata directories after building the metadata.
    .DESCRIPTION
        Production permission sets contain Xml nodes that are not needed when adding new permissions. These nodes will
        be stripped out of the permission set file and only nodes with positive or true values will remain.
    .PARAMETER SourceDir
        The source director that holds the templates folder
    .PARAMETER SObjectApiName
        The SObject full Api name (including __c if custom)
    .PARAMETER SObjectPluralName
        The plural name of the SObject
    .PARAMETER FieldApiName
        The implementation full Api name (including __c if custom)
    .PARAMETER FieldValuesByClassDetails
        Hashtable of implementation field values and class details for each implementation. The field value is what is
        stored on the record implementation field and the custom metadata implementation key. the class details will be
        part of the implementation interface and class names. Example: [SObjectPluralName][ClassDetail]Service

        Note: The class details should only include alphabetical characters. The script will remove any other characters
        if included.
    .PARAMETER Author
        The name noted for @author in the class description
    .PARAMETER ApiVersion
        The Api version to use in the class xml files
    .EXAMPLE
        # Set the field values by class details hashtable
        $fieldValuesByClassDetails = @{
            "ImplementationOne" = "Implementation Field Value One"
            "ImplementationTwo" = "Implementation Field Value Two"
        }
        Build-ServiceImplMetadata -sourceDir "D:\buildServiceImplementation" -sObjectApiName "Lead" `
         -sObjectPluralName "Leads" -fieldApiName "Record_Type_Developer_Name__c" `
         -fieldValuesByClassDetails $fieldValuesByClassDetails -author "Your Name Here" -apiVersion "48.0"
    .EXAMPLE
        # Set the field values by class details hashtable
        $fieldValuesByClassDetails = @{
            "ImplementationOne" = "Implementation Field Value One"
            "ImplementationTwo" = "Implementation Field Value Two"
        }
        Build-ServiceImplMetadata -sourceDir "~/buildServiceImplementation" -sObjectApiName "CustomObject__c" `
         -sObjectPluralName "CustomObjects" -fieldApiName "Record_Type_Developer_Name__c" `
         -fieldValuesByClassDetails $fieldValuesByClassDetails -author "Your Name Here" -apiVersion "48.0"
    #>

    param(
        [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sourceDir,
        [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sObjectApiName,
        [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sObjectPluralName,
        [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$fieldApiName,
        [parameter(Mandatory)][ValidateNotNullOrEmpty()][hashtable]$fieldValuesByClassDetails,
        [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$author,
        [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$apiVersion
    )

    Set-StrictMode -Version Latest
    $ErrorActionPreference = "Stop"
    $PSDefaultParameterValues['*:ErrorAction']='Stop'

    # Template directory
    $templateDir = "$($sourceDir)\templates"

    # Test if template directory exists and process
    if ((Test-Path $templateDir)) {

        # SObject Names
        $sObject = $sObjectApiName -replace "__c", ""
        $sObjectLower = $sObject.ToLower() -replace "_", " "

        $sObjectVar = $sObjectLower
        if ($sObjectLower.Contains(" ")) {
            $sections = $sObjectLower -split " "
            $sObjectVar = $sections[0]
            for ($i = 1; $i -lt $sections.Count; $i++) {
                $sObjectVar += (Get-Culture).TextInfo.ToTitleCase($sections[$i])
            }
        }
        $sObjectPluralName = $sObjectPluralName -replace "_", ""

        # Metadata directories (create if they don't exist)
        $destinationRoot = "$($sourceDir)\metadata\$($sObject)\"
        $classesDir = "$($sourceDir)\metadata\$($sObject)\classes"
        $customMetadataDir = "$($sourceDir)\metadata\$($sObject)\customMetadata\"
        $triggerDir = "$($sourceDir)\metadata\$($sObject)\triggers\"

        $paths = @($classesDir, $customMetadataDir, $triggerDir)

        foreach ($path in $paths) {
            if (!(Test-Path $path)) {
                New-Item -ItemType Directory -Force -Path $path | Out-Null
            } else {
                Remove-Item $path\*.*
            }
        }

        # Create package.xml
        $packageXmlTemplate = "$templateDir\packageXml.template"
        $packageXmlDestination = "$($destinationRoot)\package.xml"
        (Get-Content $packageXmlTemplate -Raw) -f $apiVersion | Set-Content $packageXmlDestination -NoNewline

        # Class xml file template
        $classXmlTemplate = "$($sourceDir)\templates\classXml.template"

        # Class for creating metadata to deploy
        class Metadata {
            [string]$template
            [array]$formats
            [string]$type
            [string]$baseFileName;
        }

        # Allow only alphabetical characters in the implementation class names
        $pattern = '[^a-zA-Z]'

        <#
        Set class and custom metdata file parameters based on templates
        #>

        # Domain
        $iDomain = [Metadata]@{
            template="$($templateDir)\IDomain.template";
            formats=@($author, $sObjectPluralName);
            type="class";
            baseFileName="I$($sObjectPluralName)"
        }
        $domain = [Metadata]@{
            template="$($templateDir)\Domain.template";
            formats=@($author, $sObjectPluralName, $sObjectApiName);
            type="class";
            baseFileName="$($sObjectPluralName)"
        }
        $domainTest = [Metadata]@{
            template="$($templateDir)\DomainTest.template";
            formats=@($sObjectPluralName, $sObjectApiName, $sObjectVar);
            type="class";
            baseFileName="$($sObjectPluralName)Test"
        }

        # Service
        $iService = [Metadata]@{
            template="$($templateDir)\IService.template";
            formats=@($author, $sObjectPluralName);
            type="class"; baseFileName="I$($sObjectPluralName)Service"
        }
        $service = [Metadata]@{
            template="$($templateDir)\Service.template";
            formats=@($author, $sObjectPluralName, $sObjectLower);
            type="class"; baseFileName="$($sObjectPluralName)Service"
        }
        $serviceTest = [Metadata]@{
            template="$($templateDir)\ServiceTest.template";
            formats=@($sObjectPluralName, $sObjectApiName, $sObject);
            type="class";
            baseFileName="$($sObjectPluralName)ServiceTest"
        }
        $serviceImpl = [Metadata]@{
            template="$($templateDir)\ServiceImpl.template";
            formats=@($author, $sObjectPluralName);
            type="class";
            baseFileName="$($sObjectPluralName)ServiceImpl"
        }

        # Selector
        $iSelector = [Metadata]@{
            template="$($templateDir)\ISelector.template";
            formats=@($author, $sObjectPluralName, $sObjectApiName);
            type="class";
            baseFileName="I$($sObjectPluralName)Selector"
        }
        $selector = [Metadata]@{
            template="$($templateDir)\Selector.template";
            formats=@($author, $sObjectPluralName, $sObjectApiName);
            type="class";
            baseFileName="$($sObjectPluralName)Selector"
        }
        $selectorTest = [Metadata]@{
            template="$($templateDir)\SelectorTest.template";
            formats=@($sObjectPluralName, $sObjectApiName);
            type="class";
            baseFileName="$($sObjectPluralName)SelectorTest"
        }

        # Manager
        $implManager = [Metadata]@{
            template="$($templateDir)\ImplManager.template";
            formats=@($author, $sObjectPluralName, $sObjectLower);
            type="class";
            baseFileName="$($sObjectPluralName)ImplManager"
        }
        $implManagerTest = [Metadata]@{
            template="$($templateDir)\ImplManagerTest.template";
            formats=@($sObjectPluralName, $sObjectApiName);
            type="class";
            baseFileName="$($sObjectPluralName)ImplManagerTest"
        }

        # Service Base
        $iSvcBase = [Metadata]@{
            template="$($templateDir)\ISvcBase.template";
            formats=@($author, $sObjectPluralName);
            type="class";
            baseFileName="I$($sObjectPluralName)SvcBase"
        }

        # Service Library
        $serviceLibrary = [Metadata]@{
            template="$($templateDir)\SvcLibrary.template";
            formats=@($author, $sObjectPluralName);
            type="class";
            baseFileName="$($sObjectPluralName)SvcLibrary"
        }

        # fflib Custom Metadata
        $cmDomain = [Metadata]@{
            template="$($templateDir)\ApplicationFactory_Domain.template";
            formats=@($sObject, $sObjectPluralName, $sObjectApiName);
            type="customMetadata";
            baseFileName="ApplicationFactory_Domain.$($sObject)"
        }
        $cmService = [Metadata]@{
            template="$($templateDir)\ApplicationFactory_Service.template";
            formats=@($sObject, $sObjectPluralName, $sObjectApiName);
            type="customMetadata";
            baseFileName="ApplicationFactory_Service.$($sObject)"
        }
        $cmSelector = [Metadata]@{
            template="$($templateDir)\ApplicationFactory_Selector.template";
            formats=@($sObject, $sObjectPluralName, $sObjectApiName);
            type="customMetadata";
            baseFileName="ApplicationFactory_Selector.$($sObject)"
        }
        $cmUnitOfWork = [Metadata]@{
            template="$($templateDir)\ApplicationFactory_UnitOfWork.template";
            formats=@($sObject, $sObjectApiName);
            type="customMetadata";
            baseFileName="ApplicationFactory_UnitOfWork.$($sObject)"
        }

        # Service SObject Custom Metadata
        $cmSObjectImpl = [Metadata]@{
            template="$($templateDir)\ServiceImplementationSObject.template";
            formats=@($sObject, $fieldApIName, $sObjectApiName);
            type="customMetadata";
            baseFileName="Service_Implementation_SObject.$($sObject)"
        }

        # Trigger
        $trigger = [Metadata]@{
           template="$($templateDir)\Trigger.template";
           formats=@($sObjectPluralName, $sObjectApiName);
           type="trigger";
           baseFileName="$($sObjectPluralName)Trigger"
       }

        $metadata = @(
            $iDomain,
            $domain,
            $domainTest
            $iService,
            $service,
            $serviceTest,
            $serviceImpl,
            $iSelector,
            $selector,
            $selectorTest
            $implManager,
            $implManagerTest,
            $iSvcBase,
            $serviceLibrary,
            $cmDomain,
            $cmService,
            $cmSelector,
            $cmUnitOfWork,
            $cmSObjectImpl,
            $trigger
        )

        # Create metadata specific service implementations for the SObject
        $fieldValuesByClassDetails.GetEnumerator() | ForEach-Object {
            $classDetail = $_.Key -replace $pattern, ""
            # Service Impl Interface
            $metadata += [Metadata]@{
                template="$($templateDir)\ISvcImpl.template";
                formats=@($author, $sObjectPluralName, $classDetail);
                type="class";
                baseFileName="I$($sObjectPluralName)Svc$($classDetail)"
            }
            # Service Impl class
            $metadata += [Metadata]@{
                template="$($templateDir)\SvcImpl.template";
                formats=@($author, $sObjectPluralName, $classDetail);
                type="class";
                baseFileName="$($sObjectPluralName)Svc$($classDetail)"
            }
            # Service Impl Custom Metadata
            $metadata += [Metadata]@{
                template="$($templateDir)\ApplicationFactory_ServiceImpl.template";
                formats=@($sObject, $sObjectPluralName, $classDetail, $_.Value);
                type="customMetadata"; baseFileName="ApplicationFactory_Service.$($sObject)$($classDetail)"
            }
        }

        $templateError = $false

        # Build metadata and save
        Write-Host `n -BackgroundColor DarkMagenta -ForegroundColor White
        Write-Host "`n `tCreating Metadata" -BackgroundColor DarkMagenta -ForegroundColor White
        Write-Host `n -BackgroundColor DarkBlue -ForegroundColor White
        $metadata | ForEach-Object {
            $processingTemplate = $_.template
            try {
                if ($_.type -eq "class") {
                    $xmlDestination = "$($classesDir)\$($_.baseFileName).cls-meta.xml"
                    $classDestination = "$($classesDir)\$($_.baseFileName).cls"
                    Write-Host "`t`tBuilding class, $($_.baseFileName)" -BackgroundColor DarkBlue -ForegroundColor White
                    (Get-Content $_.template -Raw) -f $_.formats | Set-Content $classDestination -NoNewline
                    (Get-Content $classXmlTemplate -Raw) -f $apiVersion | Set-Content $xmlDestination -NoNewline
                }
                if ($_.type -eq "customMetadata") {
                    $destination = "$($customMetadataDir)\$($_.baseFileName).md"
                    Write-Host "`t`tBuilding custom metadata, $($_.baseFileName)" -BackgroundColor DarkBlue `
                    -ForegroundColor White
                    (Get-Content $_.template -Raw) -f $_.formats | Set-Content $destination -NoNewline
                }
                if ($_.type -eq "trigger") {
                    $destination = "$($triggerDir)\$($_.baseFileName).trigger"
                    Write-Host "`t`tBuilding trigger, $($_.baseFileName)" -BackgroundColor DarkBlue `
                     -ForegroundColor White
                    (Get-Content $_.template -Raw) -f $_.formats | Set-Content $destination -NoNewline
                }
            } catch {
                Write-Host `n -BackgroundColor DarkRed -ForegroundColor White
                Write-Host "`tThe was a problem processing template, $($processingTemplate)" -BackgroundColor DarkRed `
                -ForegroundColor White
                Write-Host "`tError: $($_)" -BackgroundColor DarkRed -ForegroundColor White
                Write-Host `n
                break
            }
        }

        if (!$templateError) {
            Write-Host `n -BackgroundColor DarkGreen -ForegroundColor White
            Write-Host "`tMetadata saved to $($destinationRoot)" -BackgroundColor DarkGreen -ForegroundColor White
            Write-Host `n
        }
    } else {
        Write-Host `n -BackgroundColor DarkRed -ForegroundColor White
        Write-Host "`tTemplate source directory, $($templateDir) does not exist. Please verify the path." `
         -BackgroundColor DarkRed -ForegroundColor White
         Write-Host `n
    }
}

Export-ModuleMember -Function "Build-ServiceImplMetadata"