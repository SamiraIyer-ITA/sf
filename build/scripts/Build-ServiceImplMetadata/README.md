# How to Use

## Install Module

Open PowerShell find your PowerShell module path by running the below command (in Linux or Mac type in pwsh in the
terminal to start PowerShell).

```bash
$Env:PSModulePath
```

Copy the Build-ServiceImplMetadata folder under PowerShell/Modules/ to one of the Module directories from the previous
command. I suggest using the PowerShell directories under your home/user directories or /opt

**Note:** If the PowerShell directory does not exist you can copy the PowerShell folder and its content to match the
directory returned from the above command.

After copying the folder to your PowerShell module directory ensure it is available to install by running the below
command. If you do not see module verify you have copied the folder to the correct directory (or you can try another
PowerShell/Modules directory). You may also need to close and open PowerShell.

```bash
Get-Module -ListAvailable
```

Install the module with the below command (note if there is a new version of the module  it can also be updated using 
the below command once the new version is copied to the module directory).

```bash
Import-Module -Name Build-ServiceImplMetadata
```

If you receive an error installing the module run the help command below. Sometimes the error is not due to the
installation and Get-Help will verify the installation.

## Copy templates directory

Copy the templates' directory within Build-ServiceImplMetadata to a local directory (other than in source control)

Notate the path where you copied the templates' folder as it will be used as a script parameter

## Get help for how to run the module

To display the help or instructions for how to use the module run the below command.

```bash
Get-Help Build-ServiceImplMetadata -detailed
```

## Example

First create a PowerShell hashtable (similar to a Map in salesforce) that will map the class details (part of the
implementation class names) to the field value for this implementation that is stored on the record. Here is an example
using Order.

```bash
$fieldValuesByClassDetails = @{
	"Events" = "Events"
	"Services" = "Services"
}
```

Run the module with required parameters (note we are passing the hashtable we created in about for the mapping). Using
Order as an example.

```bash
Build-ServiceImplMetadata -sourceDir "D:\buildServiceImplementation" -sObjectApIName "Order" `
 -sObjectPluralName "Orders" -fieldApiName "Record_Type_Developer_Name__c" `
 -fieldValuesByClassDetails $fieldValuesByClassDetails -author "Andrew La Russa" -apiVersion "48.0"

# You can also run the command standalone and PowerShell will prompt you for all required parameters

Build-ServiceImplMetadata
```

The metadata is saved to the source directory originally provided for the templates under metatdata/[SObject].

**Note:** This also creates all the fflib classes and custom metadata as well, so please verify you are not deploying over
existing metadata. If you do not need those classes or metadata they can be removed from the classes and customMetadata
directories after building the metadata.