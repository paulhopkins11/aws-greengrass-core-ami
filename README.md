This project builds a simple ami from Amazon Linux and installs AWS Greengrass Core V1:

## Building

This is built using [packer.io](https://www.packer.io/). First step is to validate:

```
$ packer validate template.json
Template validated successfully.
```
Next is the build:
```
$ packer build --var 'aws_profile=<YOUR_AWS_PROFILE>' template.json
...
```
*OPTIONS:* You can also choose to include these variable overrides
```
--var 'aws_ami_name=<YOUR_AWS_AMI_NAME>'
--var 'aws_region=<YOUR_AWS_REGION>'
--var 'source_ami_id=<YOUR_AWS_AMI>'
```

*NOTE:* This depends on an AWS cli profile being set using `aws configure`

## Running

Once you start and EC/2 instance from this AMI you need to perform some setup steps:

1. Create your Core Certificates

```
mkdir certs/
echo Core Certificate ARN = $(aws iot create-keys-and-certificate \
    --profile <YOUR_AWS_PROFILE> \
    --region <YOUR_AWS_REGION> \
    --set-as-active \
    --certificate-pem-outfile certs/core.cert.pem \
    --public-key-outfile certs/core.public.key \
    --private-key-outfile certs/core.private.key | jq '.certificateArn' -r)
```
2. Copy your core certs to your EC2 instance

```
scp -i <YOUR_PEM>.pem certs/core* ec2-user@<YOUR_PUBLIC_DNS_NAME>:~/
```

3. SSH into your EC2

```
ssh -i <YOUR_PEM>.pem certs/core* ec2-user@<YOUR_PUBLIC_DNS_NAME>
```

4. Move your core certs into the Greengrass certs directory

```
sudo cp ~/core* /greengrass/certs
```

5. Update the Greengrass config

```
sudo vi /greengrass/config/config.json
```

6. Start the Greengrass core

```
cd /greengrass/ggc/core/
sudo ./greengrassd start
# Tail the server log
sudo tail -f /greengrass/ggc/var/log/system/runtime.log
```
The logs should show your core successfully connecting

7. Deploy your Group in the AWS Console

You should see this complete successfully and also see log messages appear in the core logs