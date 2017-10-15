# Nginx logrotate with Amazon S3 Tools
Generic shell script to upload / synchronize log files (ubuntu) to Amazon AWS S3 buckets for centralized log management based on [Nginx](https://www.digitalocean.com/community/tutorials/how-to-configure-logging-and-log-rotation-in-nginx-on-an-ubuntu-vps) example.

Most approaches, at least all I found, had the following limitations:
* Sharedscripts directive of logrotate, executes scripts in pre- and postrotate only once
Solution: Relocate scripts to lastaction, execute upload script in prerotate and deactivate sharedscripts (nosharedscripts is default)
* Logs in a directory (wildcard usage) not dynamically handled
Solution: Hand over rotated file with $1 variable
* File handed over in $1 variable contains fully qualified log path
Solution: Process file path and extract file name
* No dynamic retrieval of instance ID
Solution: Replace IP of server with generic address "instance-data"
* Logs from different servers with same name overwrite each other when i.e. leveraging [AWS AutoScaling](https://aws.amazon.com/de/autoscaling/)

## Centralized log storage use cases
1. Redundancy: Log storage in S3 is a high redundancy, infinite scaleable fallback
2. Access: Centralized S3 log storage allows providing access third parties
3. Analysis: Saving in centralized location enables easy retrieval i.e. through [Knime S3 Connector](https://www.knime.com/nodeguide/data-access/zip-and-remote-files/amazon-s3-remote-file-example) leveraged for advanced analysis

### Prerequisites
1. Create an S3 bucket to store the logs in. Pay attention to the region you create it in.
2. Create am [AWS IAM policy](https://docs.aws.amazon.com/AmazonS3/latest/dev/example-policies-s3.html#iam-policy-ex0) granting access to the former bucket
3. Create an Amazon IAM user (Programmatic access), save the access plus secret key and assigning him to the role
4. Install [s3cmd](https://github.com/s3tools/s3cmd) `sudo apt-get install s3cmd` or from [github s3tools / s3cmd](https://github.com/s3tools/s3cmd)
5. Configure `s3cmd --configure` and enter the access as well as the secret key from step three
6. Test upload and access rights by `s3cmd put YOUR_FILE s3://YOUR_BUCKET_NAME/`

### Installing
1. Download synchronization script [upload-log-s3.sh](https://raw.githubusercontent.com/mikeg-de/nginx-logrotate/master/upload-log-s3.sh) `wget https://raw.githubusercontent.com/mikeg-de/nginx-logrotate/master/upload-log-s3.sh`
2. Make downloaded file upload-log-s3.sh executable `sudo chmod +x upload-log-s3.sh`
3. Modify the script in accordance to the bucket you created
4. Download [nginx](https://raw.githubusercontent.com/mikeg-de/nginx-logrotate/master/nginx) file for logrotate `sudo wget https://raw.githubusercontent.com/mikeg-de/nginx-logrotate/master/nginx -P /etc/logrotate.d/`
5. Modify file path to upload-log-s3.sh based on where you have downloaded it to
6. Test upload during logrotate by `sudo logrotate -f /etc/logrotate.d/nginx` and check the file(s) in your S3 bucket

## Versioning
0.2 Current Release
* Removed seconds from S3 sub-folder for better overview
* Updated readme

0.1 Initialization

## To be done ##
Suggestions welcome!

## Authors
**Mike Wiegand** - [atMedia Online Marketing](https://atmedia-marketing.com)

See also the list of [Acknowledgments](#acknowledgments) where their work greatly contributed to this project.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments
* [Logrotate Manual](https://linuxconfig.org/logrotate-8-manual-page) for details about logrotate commands
* [Yasith Fernando](http://ghost.thekindof.me/setting-up-centralized-logging-to-s3-with-logrotated/)
* [Dowd and Associates](http://www.dowdandassociates.com/blog/content/howto-rotate-logs-to-s3/)
