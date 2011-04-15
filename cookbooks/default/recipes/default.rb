#
# Cookbook Name:: default
# Recipe:: default
#
# Copyright 2011, Example Com
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

groups = Hash.new
sysadmin_group = Array.new
safe_group = Array.new
users_group = Array.new

search(:users, 'groups:[* TO *]').each do |u|
  sysadmin_group << u['id'] if Array(u['groups']).include? "sysadmin"
  safe_group << u['id'] if Array(u['groups']).include? "safe"
  users_group << u['id']
  home_dir = "/home/#{u['id']}"

  user u['id'] do
    uid u['uid']
    shell u['shell']
    comment u['comment']
    supports :manage_home => true
    home home_dir
    action [:create, :manage]
  end

  group 'sudo' do
    members u['id']
  end

  directory "#{home_dir}/.ssh" do
    owner u['id']
    group "users" # u['id']
    mode "0700"
  end

  template "#{home_dir}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    owner u['id']
    group "users" # u['id']
    mode "0600"
    variables :ssh_keys => u['ssh_keys']
  end
end

template "/etc/sudoers" do
  mode '0440'
end
