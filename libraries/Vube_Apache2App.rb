module Vube
    module Apache2App

        def getDocroot(app)

            if app["docroot"]
                docroot = app["docroot"]

            elsif node["apache2_apps"]["docroot"][0,1] == "/"
                # docroot is an absolute path
                docroot = node["apache2_apps"]["docroot"]

            elsif node["apache2_apps"]["docroot"] == ""
                # There is no specific docroot, the entire app dir is the docroot
                docroot = node["apache2_apps"]["base_apps_dir"] + "/" + app["id"]

            else
                # docroot is a relative path under the app dir
                docroot = node["apache2_apps"]["base_apps_dir"] + "/" + app["id"] + "/" + node["apache2_apps"]["docroot"]
            end

            # Return docroot
            docroot
        end

        def configureApp(app)

            # Make sure docroot is defined and points to an absolute location
            app["docroot"] = getDocroot(app)

            # Set empty aliases array if necessary
            if !app["aliases"]
                app["aliases"] = Array.new(0)
            end

            # Disable SSL unless it is specifically enabled
            app["https_enabled"] = app["https_enabled"] ? app["https_enabled"] : false

            # If there are no apache owned directories, initialize a default
            if !app["internal_ips"]
                app["internal_ips"] = ["localhost"]
            end

            # If there are no apache owned directories, initialize an empty array
            if !app["apache_owned_directories"]
                app["apache_owned_directories"] = Array.new(0)
            end

            # Return app with everything configured
            app
        end

        # Add host to /etc/hosts only if we haven't already done so
        def setEtcHostEntry(host)

            bash "/etc/hosts #{host}" do
                code "echo '127.0.0.1 #{host} # added by Chef' >> /etc/hosts"
                only_if { `grep '127.0.0.1 #{host} # added by Chef' /etc/hosts`.to_s.empty? }
            end

        end

        # Add host info in /etc/hosts
        def editEtcHosts(app)

            setEtcHostEntry(app["host"])

            app["aliases"].each do |host|
                setEtcHostEntry(host)
            end

        end

        def setupApacheOwnedDirectories(app)

            # Create/Modify world-writeable directories
            app["apache_owned_directories"].each do |path|

                # If path isn't absolute, then it must be relative to the docroot
                if path[0,1] != "/"
                    path = app["docroot"] + "/" + path
                end

                # Create the directory owned by apache user and writable by apache group
                # NOTE: This does NOT work if the dir is under the /vagrant/ dir, probably
                # because that is mapped to the host OS
                directory path do
                    owner node["apache"]["user"]
                    group node["apache"]["group"]
                    mode 0775
                    action :create
                    recursive true
                end

            end

        end

    end
end

Chef::Recipe.send(:include, Vube::Apache2App)
