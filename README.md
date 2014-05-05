# chef-init-apache2-apps

Easily install and configure Apache2 web apps via this Chef cookbook.


## Configuration

You can install and configure any number of Apache2 apps via a data_bag
that contains all the apps you wish to configure.

### `data_bags/apache2_apps/my_app.json`

```json
{
    "id": "my_app",
    "host": "my-app.com",
    "aliases": [
        "www.my-app.com"
    ]
}
```

You can configure/install multiple apps by creating 1 JSON file per app
in the apache2_apps data_bag.


## Usage

The easiest way to use this is to include it as a submodule in your project.
Makes sure you put it somewhere in your cookbook search path.

For example:

```bash
$ git submodule add https://github.com/vube/chef-init-apache2-apps
```

Then you will want to list this as a dependency in your `metadata.rb`

```ruby
depends "chef-init-apache2-apps"
```

Finally, you need to include this recipe from one of the recipes on your run list.

```ruby
include_recipe "chef-init-apache2-apps"
```
