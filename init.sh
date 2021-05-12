#!/bin/bash

apt -y update
apt -y upgrade
apt -y install nginx
systemctl enable nginx
rm -f /var/www/html/index*.html
(
cat > /var/www/html/index.html << EOF
<html>
<head>
Hello from the bucket
</head>
<body>
S3 FTW
</body>
</html>
EOF
)
systemctl start nginx
systemctl restart nginx

echo '                                                  DONE'
echo '==================================================================================================='


