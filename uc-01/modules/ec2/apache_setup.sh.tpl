#!/bin/bash
yum update -y
yum install -y httpd

mkdir -p /var/www/html${path}

cat <<EOT > /var/www/html${path}/index.html
<html>
<head><title>${name}</title></head>
<body>
  <h1>${html}!</h1>
  <p>(${name})</p>
</body>
</html>
EOT

%{ if path != "/" }
echo "<VirtualHost *:80>
  Alias ${path} /var/www/html${path}
  <Directory /var/www/html${path}>
    Require all granted
  </Directory>
</VirtualHost>" > /etc/httpd/conf.d/${name}.conf
%{ endif }

/bin/rm -f /etc/httpd/conf.d/welcome.conf
systemctl start httpd
systemctl enable httpd
