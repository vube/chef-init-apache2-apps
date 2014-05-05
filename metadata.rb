name             'chef-init-apache2-apps'
maintainer       'Vubeology, LLC'
maintainer_email 'ross@vubeology.com'
license          'MIT'
description      'Easily install and configure apache2 web apps'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends "apache2"
