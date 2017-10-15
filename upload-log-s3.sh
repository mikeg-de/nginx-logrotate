if [ -z $1 ]; then
echo "Error: no filename passed in... Exiting..."
exit;
fi

echo 'Starting S3 Log Upload...'

# Extract file anme from path
path = $1
file="${path##*/}"
file="$file"

BUCKET_NAME="ubunut-elb-logs"
# Time stamp and instance id for bucket sub-folders
timestamp=$(date +"%Y%m%d-%H%M")
# Dynamically retreive instance ID and replace i- with nothing
EC2_INSTANCE_ID="`wget -q -O - http://instance-data/latest/meta-data/instance-id | sed -e s/i-//`"

if [ -z $EC2_INSTANCE_ID ]; then
echo "Error: Couldn't fetch Instance ID .. Exiting .."
exit;
else

# Upload log file to Amazon S3 bucket
/usr/bin/s3cmd -c /.s3cfg sync $1 s3://$BUCKET_NAME/$EC2_INSTANCE_ID/$timestamp/

fi
