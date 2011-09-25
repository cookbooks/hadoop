#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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
#

include_recipe "java"

execute "apt-get update" do
  action :nothing
end

template "/etc/apt/sources.list.d/cloudera.list" do
  owner "root"
  mode "0644"
  source "cloudera.list.erb"
  notifies :run, resources("execute[apt-get update]"), :immediately
end

# trust the cloudera repository
package "curl"
execute "curl -s http://archive.cloudera.com/debian/archive.key | apt-key add -"

# package "hadoop" causes the following error ob ubuntu 10.04:
# [Sun, 25 Sep 2011 02:38:48 -0700] FATAL: Chef::Exceptions::Package: package[hadoop] (hadoop::default line 34) 
# had an error: apt does not have a version of package hadoop
# installing it manually work, though
if platform?("ubuntu")
  execute "apt-get -y install hadoop"
else
  package "hadoop"
end
