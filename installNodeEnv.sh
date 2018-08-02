#!/bin/bash

#### 此处是注释开始 ####
# https://wiki.jikexueyuan.com/project/shell-tutorial/shell-comment.html
# https://cloud.tencent.com/developer/labs/gallery
#### 此处是注释结束 ####


sudo su
wget https://nodejs.org/dist/v6.10.3/node-v6.10.3-linux-x64.tar.xz
tar xvJf node-v6.10.3-linux-x64.tar.xz
mv node-v6.10.3-linux-x64 /usr/local/node-v6
ln -s /usr/local/node-v6/bin/node /bin/node
ln -s /usr/local/node-v6/bin/npm /bin/npm
echo 'export PATH=/usr/local/node-v6/bin:$PATH' >> /etc/profile
source /etc/profile
npm install express-generator -g
cd /data/
express yourApp
cd yourApp
npm install
npm start
