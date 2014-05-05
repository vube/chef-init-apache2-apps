#
# Cookbook Name:: chef-init-apache2-apps
# Recipe:: default
#
# Copyright 2014, Vubeology LLC
#

include_recipe "apache2"


# Initialize apache2-apps data bag
apps = []
begin
    apps = data_bag(node["apache2_apps"]["data_bag_name"])
rescue
    Chef::Log.warn "Failed to load #{node["apache2_apps"]["data_bag_name"]} data_bag"
end

# Configure apps
apps.each do |name|

    app = data_bag_item(node["apache2_apps"]["data_bag_name"], name)
    app = configureApp(app)

    # Add app to apache config
    web_app app["host"] do
        template "virtualhost.conf.erb"
        server_name app["host"]
        server_aliases app["aliases"]
        server_include app["include"]
        docroot app["docroot"]
        https_enabled app["https_enabled"]
        internal_ips app["internal_ips"]
    end

    # Add entries to /etc/hosts
    editEtcHosts(app)

    # Configure any directories owned by the web server
    setupApacheOwnedDirectories(app)

end
