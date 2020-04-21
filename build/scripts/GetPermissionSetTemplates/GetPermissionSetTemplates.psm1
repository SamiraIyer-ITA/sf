# Format XML function
function Format-XML ([xml]$xml, $indent = 4) {
    $stringWriter = New-Object System.IO.StringWriter
    $xmlWriter = New-Object System.XMl.XmlTextWriter $stringWriter
    $xmlWriter.Formatting = [System.Xml.Formatting]::Indented
    $xmlWriter.Indentation = $indent
    $xml.WriteContentTo($xmlWriter)
    $xmlWriter.Flush()
    $stringWriter.Flush()
    Write-Output $stringWriter.ToString()
}
function GetPermissionSetTemplates {
    
    <#
    .SYNOPSIS
        Creates permission set templates from production source
    .DESCRIPTION
        Production permission sets contain Xml nodes that are not needed when adding new permissions. These nodes will
        be stripped out of the permission set file and only nodes with positive or true values will remain.
    .PARAMETER SourceDir
        The source director of the permission sets that need to modified into templates
    .PARAMETER OutputDir
        The output directory where the modified permission sets will be saved
    .EXAMPLE
        Get-PermissionSetTemplates -sourceDir "C:\salesforce\src\permissionsets\" -outputDir "C:\permissionsets\templates\"
    .EXAMPLE
        Get-PermissionSetTemplates -sourceDir "~/salesforce/src/permissionsets/" -outputDir "C:~/permissionsets/templates/"
    #>

    param(
        [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sourceDir, 
        [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$outputDir
    )

    # Test paths
    if (!(Test-Path $sourceDir) -or !(Test-Path $outputDir)) {
        throw "Source or output directory could not be resolved."
    }

    # Permission Sets files
    $permissionSets = Get-ChildItem $sourceDir*.permissionset;

    # Test if we have permissions sets to process
    if (!$permissionSets) {
        throw "Source diretory does not contain any permission set files."
    }

    # Number of permission sets to process
    $count = $permissionSets.count

    # Keep track of the current permission set being modified
    $i = 1

    # Loop through permission set directory
    $permissionSets | ForEach-Object {

        # Update progress
        Write-Progress -Activity "Processing permission set $($_.BaseName):" -Status "$($i) of $($count)" -PercentComplete (($i / $count)  * 100)

        # Get current permission set as Xml
        [xml]$xml = Get-Content $_.FullName

        # Set Xml Namespace (needed to select child nodes)
        $ns = New-Object Xml.XmlNamespaceManager $xml.NameTable
        $ns.AddNamespace("meta", "http://soap.sforce.com/2006/04/metadata")

        # applicationVisibilities
        $xml.SelectNodes("//meta:applicationVisibilities", $ns) | ForEach-Object {
            if ($_.visible -eq "false") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # classAccesses
        $xml.SelectNodes("//meta:classAccesses", $ns) | ForEach-Object {
            if ($_.enabled -eq "false") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # customMetadataTypeAccesses
        $xml.SelectNodes("//meta:customMetadataTypeAccesses", $ns) | ForEach-Object {
            if ($_.enabled -eq "false") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # customPermissions
        $xml.SelectNodes("//meta:customPermissions", $ns) | ForEach-Object {
            if ($_.enabled -eq "false") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # externalDataSourceAccesses
        $xml.SelectNodes("//meta:externalDataSourceAccesses", $ns) | ForEach-Object {
            if ($_.enabled -eq "false") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # hasActivationRequired
        $hasActivationRequired = $xml.SelectSingleNode("//meta:hasActivationRequired", $ns)
        if ($hasActivationRequired."#text" -eq "false") { 
            $hasActivationRequired.ParentNode.RemoveChild($hasActivationRequired) | Out-Null
        }

        # fieldPermissions
        $xml.SelectNodes("//meta:fieldPermissions", $ns) | ForEach-Object {
            if ($_.editable -eq "false" -and $_.readable -eq "false") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # objectPermissions
        $xml.SelectNodes("//meta:objectPermissions", $ns) | ForEach-Object {
            if ($_.allowCreate -eq "false" -and $_.allowDelete -eq "false" -and
                    $_.allowEdit -eq "false" -and $_.allowRead -eq "false" -and
                    $_.modifyAllRecords -eq "false" -and $_.viewAllRecords -eq "false") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # pageAccesses
        $xml.SelectNodes("//meta:pageAccesses", $ns) | ForEach-Object {
            if ($_.enabled -eq "false") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # recordTypeVisibilities
        $xml.SelectNodes("//meta:recordTypeVisibilities", $ns) | ForEach-Object {
            if ($_.visible -eq "false") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # tabSettings
        $xml.SelectNodes("//meta:tabSettings", $ns) | ForEach-Object {
            if ($_.visibility -eq "None") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # userPermissions
        $xml.SelectNodes("//meta:userPermissions", $ns) | ForEach-Object {
            if ($_.enabled -eq "false") {
                $_.ParentNode.RemoveChild($_) | Out-Null
            }
        }

        # Xml template file to save
        $xmlTemplate = "$($outputDir)$($_.Name)"

        # Format amd save Xml
        Format-XML ([xml]$xml.OuterXml) | Out-File $xmlTemplate 

        # Increment current permssion set number
        $i = $i + 1
    }       
}

Export-ModuleMember -Function "GetPermissionSetTemplates"