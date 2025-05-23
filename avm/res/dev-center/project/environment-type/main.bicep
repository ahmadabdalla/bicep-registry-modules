metadata name = 'Dev Center Project Environment Type'
metadata description = 'This module deploys a Dev Center Project Environment Type.'

@sys.description('Required. The name of the environment type.')
@minLength(3)
@maxLength(63)
param name string

@sys.description('Conditional. The name of the parent dev center project. Required if the template is used in a standalone deployment.')
param projectName string

resource project 'Microsoft.DevCenter/projects@2025-02-01' existing = {
  name: projectName
}

resource environmentType 'Microsoft.DevCenter/projects/environmentTypes@2025-02-01' = {
  parent: project
  name: name
}
