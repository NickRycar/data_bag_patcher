#
# Cookbook Name::data_bag_patcher
# Recipe:: provision
#
# Copyright 2016 Nick Rycar
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

databag="#{node['delivery']['config']['data_bag_patcher']['os']}_patchlist"
data_bag_path = File.join(node['delivery']['workspace']['repo'], node['delivery']['config']['delivery-bag']['data-bag-repo-path'], databag)

new_data_bag = "#{data_bag_path}/#{delivery_environment}.json"
scrubbed_env = delivery_environment

old_data_bag = "#{data_bag_path}/updates.json"

# pseudo-code
# if delivered_environment = acceptance then
# copy updates.json to acceptance.json

execute 'cp databag to environment' do
  command "sed -e 's/ENVIRONMENT/#{scrubbed_env}/g' #{old_data_bag} > #{new_data_bag}"
  action :run
end

# update the data bag item for env `knife data bag from file databag_name item`
execute 'Upload Data Bag Item to Chef Server' do
  command "knife data bag from file --config #{delivery_knife_rb}  #{databag} #{new_data_bag}"
  action :run
end