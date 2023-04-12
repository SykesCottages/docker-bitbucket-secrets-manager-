FROM amazon/aws-cli:2.2.13

RUN yum install jq -y
RUN curl -fsSL -o /common.sh https://bitbucket.org/bitbucketpipelines/bitbucket-pipes-toolkit-bash/raw/0.6.0/common.sh

COPY pipe /
COPY LICENSE README.md /

ENTRYPOINT ["/pipe.sh"]