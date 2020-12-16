echo "Install greengrass core"

sudo yum update -y

# Taken from https://docs.aws.amazon.com/greengrass/latest/developerguide/setup-filter.ec2.html

# 4.
sudo adduser --system ggc_user
sudo groupadd --system ggc_group

# 5.
# No need to adjust hardlinks and softlinks

# 6.
curl https://raw.githubusercontent.com/tianon/cgroupfs-mount/951c38ee8d802330454bdede20d85ec1c0f8d312/cgroupfs-mount > cgroupfs-mount.sh
chmod +x cgroupfs-mount.sh 
sudo bash ./cgroupfs-mount.sh

# 7.
sudo yum install java-1.8.0-openjdk -y
sudo ln /etc/alternatives/java /usr/bin/java8

# Dependent Apps
# Python 3.7
sudo yum install python37 -y
# Nodejs 12
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install 12
sudo ln ~/.nvm/versions/node/v12.20.0/bin/node ~/.nvm/versions/node/v12.20.0/bin/nodejs12.x
sudo ln ~/.nvm/versions/node/v12.20.0/bin/node ~/.nvm/versions/node/v12.20.0/bin/nodejs12.20
nodejs12.x -e "console.log('Running Node.js ' + process.version)"

# 8.
mkdir greengrass-dependency-checker-GGCv1.11.x
cd greengrass-dependency-checker-GGCv1.11.x
wget https://github.com/aws-samples/aws-greengrass-samples/raw/master/greengrass-dependency-checker-GGCv1.11.x.zip
unzip greengrass-dependency-checker-GGCv1.11.x.zip
cd greengrass-dependency-checker-GGCv1.11.x
# TODO - check_ggc_dependencies still reports no node installed correctly
sudo ./check_ggc_dependencies

# Install the root cert
sudo wget -O root.ca.pem https://www.amazontrust.com/repository/AmazonRootCA1.pem
# If installing natively on EC2 - Download greengrass core
wget https://d1onfpft10uf5o.cloudfront.net/greengrass-core/downloads/1.11.0/greengrass-linux-x86-64-1.11.0.tar.gz
sudo tar -xzvf greengrass-linux-x86-64-1.11.0.tar.gz -C /
sudo cp root.ca.pem /greengrass/certs
