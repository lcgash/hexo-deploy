#!/bin/sh -l

set -e

# deploy to
echo "Deploy to ${TARGET_REPOSITORY}"

# Installs Git.
apt-get update && \
apt-get install -y git && \

# Directs the action to the the Github workspace.
cd "${GITHUB_WORKSPACE}"

# mv ssh key
if [ ! -d "/root/.ssh" ];then
  mkdir -p /root/.ssh
fi
if [ ! -d "~/.ssh" ];then
  mkdir -p ~/.ssh
fi
cp -rf ssh/* /root/.ssh
chmod 600 /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa.pub

cp -rf ssh/* ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa.pub
ls -l ~/.ssh/


echo "npm install ..."
npm install

echo "Clean folder ..."
./node_modules/hexo/bin/hexo clean

echo "Generate file ..."
./node_modules/hexo/bin/hexo generate

echo "Deploy file ..."
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@163.com"

./node_modules/hexo/bin/hexo deploy
