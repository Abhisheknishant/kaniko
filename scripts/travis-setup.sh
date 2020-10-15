#!/bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex
if [ "$(uname -m)" == "aarch64" ]
then
  arch1="arm64"
else
  arch1="amd64"
fi
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=$arch1] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce
if [ "$(uname -m)" == "aarch64" ]
then
  wget -O container-diff-linux-arm64 https://drive.google.com/file/d/1LcJAIlOoU5EEBf5x0aXgrJTYsyDGvbLG/view?usp=sharing
  sudo mv container-diff-linux-arm64 /usr/local/bin/container-diff
else
  curl -LO https://storage.googleapis.com/container-diff/latest/container-diff-linux-amd64 && chmod +x container-diff-linux-amd64 && sudo mv container-diff-linux-amd64 /usr/local/bin/container-diff
fi
docker run -d -p 5000:5000 --restart always --name registry registry:2

mkdir -p $HOME/.docker/
echo '{}' > $HOME/.docker/config.json
