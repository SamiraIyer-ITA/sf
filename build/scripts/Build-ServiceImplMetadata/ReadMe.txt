How to use:

1) Install Module

- Open PowerShell find your PowerShell module path by running the below command (in Linux or Mac type in pwsh in the
terminal to start PowerShell).

$Env:PSModulePath

- Copy the Build-ServiceImplMetadata folder under PowerShell\Modules\ to one of the Module directories from the previous
command. I suggest using the PowerShell directories under your home/user directories or /opt

- After copying the folder to your PowerShell module directory ensure it is available to install by running the below
command. If you do not see module verify you have copied the folder to the correct directory (or you can try another
PowerShell/Modules directory). You may also need to close and open PowerShell.

Get-Module -ListAvailable

- Install the module with the below command (note if the module is updated, it can also be updated using the below
command once the new version is copied to the module directory).

Import-Module -Name Build-ServiceImplMetadata

- If you receive an error install the module run the help command in step 3 below as sometimes the error is not related
to the install and Get-Help will verify the install.

2) Copy templates directory

- Copy the templates directory within Build-ServiceImplMetadata to a local directory (other than in source control)

- Notate the path where you copied the templates folder as it will be used as a script parameter

3) Get help for how to run the module

- To display the help or instructions for how to use the module run the below command.

4) Example

- First create a PowerShell hashtable (similar to a Map in salesforce) that will map the class details (part of the
implementation class names) to the field value for this implementation that is stored on the record. Here is an example
using Order.

$fieldValuesByClassDetails = @{
    "Events" = "Events"
    "Services" = "Services"
}

- Run the module with required parameters (note we are passing the hashtable we created in about for the mapping). Using
Order as an example.

Build-ServiceImplMetadata -sourceDir "D:\buildServiceImplementation" -sObjectApIName "Order" `
 -sObjectPluralName "Orders" -fieldApiName "Record_Type_Developer_Name__c" `
 -fieldValuesByClassDetails $fieldValuesByClassDetails -author "Andrew La Russa" -apiVersion "48.0"

# You can also run the command standalone and PowerShell will prompt you for all required parameters

Build-ServiceImplMetadata

- The metadata is saved to source directory originally provided for the templates under metatdata\[SObject].

Note: This also creates all the fflib classes and custom metadata as well, so please verify you are not deploying over
existing metadata. If you do not need those classes or metadata they can be removed the from classes and customMetadata
directories after building the metadata.








