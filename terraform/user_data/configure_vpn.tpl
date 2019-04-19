apt install -y jq awscli

# Instance ID captured through Instance meta data
INSTANCE_ID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`

# Associating public 
aws ec2 associate-address --instance-id ${INSTANCE_ID} --allocation-id ${ALLOCATION_ID} --allow-reassociation
