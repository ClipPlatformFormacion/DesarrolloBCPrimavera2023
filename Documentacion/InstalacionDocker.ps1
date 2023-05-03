#Install-Module -Name BcContainerHelper -Force

$artifactUrl = Get-BCArtifactUrl -country es -select Latest -type Sandbox -version 20.5

New-BcContainer `
    -accept_eula `
    -artifactUrl $artifactUrl `
    -auth UserPassword `
    -containerName BC20CU5ES `
    -includeTestLibrariesOnly `
    -includeTestToolkit `
    -updateHosts `
    -useBestContainerOS `
    -dns '8.8.8.8'