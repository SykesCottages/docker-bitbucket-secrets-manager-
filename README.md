# Bitbucket Pipelines Pipe:  

Access AWS secrets manager in your Bitbucket pipeline.

## YAML Definition

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:

```yaml
- pipe: sykescottages/weishaupt
    FILE: '<string>'
    AWS_ACCESS_KEY_ID: '<string>'
    AWS_ACCESS_KEY_ID: '<string>'
    AWS_SECRET_ACCESS_KEY: '<string>'
    AWS_SECRET_NAME: '<string>'
    AWS_REGION: '<string>'
    AWS_PROFILE: '<string>'
    CONFIG: '<string>'  
```

## Variables

| Variable              | Usage                                                       |
| --------------------- | ----------------------------------------------------------- |
| FILE             | File Name you Wish you save to. Default .env|
| AWS_ACCESS_KEY_ID (*)              | AWS key id. |
| AWS_SECRET_ACCESS_KEY (*) | AWS secret key. |
| AWS_SECRET_NAME (*) | The name of the secret. |
| AWS_REGION (*) | AWS region. |
| AWS_PROFILE (*) | The name of the AWS profile. eg default, production, non-prod, staging, dev |
| CONFIG               | Path to aws config file eg (s3) |
_(*) = required variable. This variable needs to be specified always when using the pipe._

#### Workspaces Variables
- $AWS_ACCESS_KEY
- $AWS_SECRET_KEY

## Prerequisites

To use this pipe you should have AWS secrets manager setup.

## Examples

Example pipe yaml

```yaml
script:
  - pipe: sykescottages/weishaupt
    variables:
      AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY
      AWS_SECRET_ACCESS_KEY: $AWS_SECRET_KEY
      AWS_SECRET_NAME: sm-s-ew1-project
      AWS_REGION: eu-west-1
      AWS_PROFILE: staging
```

## Support
If you’d like help with this pipe, or you have an issue, send a message to the, [Weishaupt Support Chat][support].

If you’re reporting an issue, please include:

- the version of the pipe
- relevant logs and error messages
- steps to reproduce

[support]: https://teams.microsoft.com/l/channel/19%3a43b1c3db8d0241a989fdd05ecce45135%40thread.tacv2/General?groupId=e18d753d-d3a7-480b-a836-1e9b42736310&tenantId=eaa371d4-1c06-444c-8d18-2adf86113297

##### Johann Adam Weishaupt
German philosopher
