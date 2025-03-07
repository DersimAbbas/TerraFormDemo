## DevOps CheatSheet

        iac-terraform/
        ├── modules/
        │   ├── webapp/
        │   │   ├── main.tf
        │   │   ├── variables.tf
        │   │   └── outputs.tf
        │   └── kubernetes/
        │       ├── main.tf
        │       ├── variables.tf
        │       └── outputs.tf
        ├── environments/
        │   ├── dev/
        │   │   ├── main.tf
        │   │   ├── variables.tf
        │   │   └── backend.tf
        │   ├── staging/
        │   │   ├── main.tf
        │   │   ├── variables.tf
        │   │   └── backend.tf
        │   └── prod/
        │       ├── main.tf
        │       ├── variables.tf
        │       └── backend.tf
        └── README.md
````yaml

#for the pipleine to wake up it needs a trigger.
trigger:
  branches:
    include:
      - master

#defining stages what the agent should do.
stages:

- stage: Build
  jobs:
  - job: Build
    displayName: 'Build Job'
    pool:
      vmImage: 'ubuntu-latest'

# Build Stage
    steps:
      - task: UseDotNet@2
        inputs:
          packageType: 'sdk'
          version: '8.x'
          installationPath: $(Agent.ToolsDirectory)/dotnet
          displayName: 'Setup .NET SDK'

 # build and release script.
      - script: |
            dotnet build --configuration Release
        displayName: "Building Solution"

 # script for publishing the build and releasing it as artifact.
      - script: |
          dotnet publish -c Release -o $(Build.ArtifactStagingDirectory)
        displayName: 'Publish Artifacts'

      - task: PublishBuildArtifacts@1
        inputs:
          PathtoPublish: $(Build.ArtifactsStagingDirectory)
          ArtifactName: drop
          publishLocation: 'Container'
