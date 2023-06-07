#Install-Module -Name BcContainerHelper -Force

$artifactUrl = Get-BCArtifactUrl -country es -select Latest -type Sandbox -version 22.1

New-BcContainer `
    -accept_eula `
    -artifactUrl $artifactUrl `
    -auth UserPassword `
    -containerName BC22CU1ES `
    -includeTestLibrariesOnly `
    -includeTestToolkit `
    -updateHosts `
    -useBestContainerOS `
    -dns '8.8.8.8'