#
# Cookbook Name:: chef-init-apache2-apps
# Attributes:: default
#
# Copyright 2014 Vubeology, LLC
#

default["apache2_apps"]["data_bag_name"] = "apache2_apps"

# Must be an absolute directory
default["apache2_apps"]["base_apps_dir"] = "/vagrant/apps"

# If absolute, the docroot of all apps will be this one directory
# If relative, it is relative to /base_apps_dir/app_name/docroot
# If empty string, docroot will be /base_apps_dir/app_name
default["apache2_apps"]["docroot"] = "docroot"
