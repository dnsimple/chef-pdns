# PowerDNS Community Cookbook

Provides resources for installing and configuring both PowerDNS authoritative and recursor. It uses the official PowerDNS repositories for packages and installs the appropiate configuration for your platform's init system.

## Build Status

[![Build Status](https://travis-ci.org/dnsimple/chef-pdns.svg?branch=master)](https://travis-ci.org/dnsimple/chef-pdns)

## Requirements

### Platforms:

- Ubuntu 14.04 and newer
- Debian 8 and newer
- RHEL 7 and newer
- CentOS 6.9 and newer

### Chef:

- Chef 13 or newer

### Init Systems:

* SysV
* systemd

## Usage

Combine the different resources in order to install, configure, and manage your PowerDNS instances. This is a list of resouces that can be used:

  | Resource                            | Functionality                                     |
  |-------------------------------------|---------------------------------------------------|
  | pdns_authoritative_install          | Installs an authoritative server                  |
  | pdns_authoritative_config           | Configures an authoritative instance              |
  | pdns_authoritative_service          | Manages an authoritative instance                 |
  | pdns_recursor_install               | Installs a recusor                                |
  | pdns_recursor_config                | Configures a recursor instance                    |
  | pdns_recursor_service               | Manages a a recursor instance                     |

To fully configure an authoritative server you need to add at least 3 resources to your recipe, `pdns_authoritative_install`, `pdns_authoritative_config` and `pdns_authoritative_service`. If you want to install any backend other than the default (bind) for the authoritative server you need to install the corresponding packages for the backend you want. There is an example for a postgresql backend in `test/cookbooks/pdns_test/recipes/`.

For a recursor use the `pdns_recursor_install`, `pdns_recursor_config`, and `pdns_recursor_service` resources in your wrapper cookbooks to install, configure, and define PowerDNS recursors. Set the different properties on the resources according to your install and configuration needs. You can see a good example of this in `test/cookbooks/pdns_test/recipes_recursor_install_single.rb`

For advanced use it is recommended to take a look at the chef resources themselves.

### Properties

#### A note about instance names

PowerDNS parses the name of the instance by breaking apart the first hyphen it sees so all virtual service names (ones without a blank string) start with the service type and a hyphen. For example:

```ruby
pdns_authoritative_config 'server_01' do
  action :create
  launch ['gpgsql']
  variables(
    gpgsql_host: '127.0.0.1',
    gpgsql_user: 'pdns',
    gpgsql_port: 5432,
    gpgsql_dbname: 'pdns',
    gpgsql_password: 'wadus'
  )
end

pdns_authoritative_service 'service_01' do
  action [:enable, :start]
end
```

Will create a file named `/etc/powerdns/pdns-server_01.conf`:

```
launch ['gpgsql']
gpgsql-host=127.0.0.1
gpgsql-user=pdns
gpgsql-port=5432
gpgsql-dbname=pdns
gpgsql-password=wadus
```

And a service named `pdns-server_01` which is symbolically linked linked to `pdns` if you are using SysVinit.

#### General note about resource properties

Most properties are simple ruby strings, but there is another cases that require special attention.
Properties specified as elements in arrays will be split up (see split ruby method) and separated by commas.
Boolean properties will be always translated to 'yes' or 'no'.
Some properties need to be set consistently accross resources, they will be noted in their specific sections at the top under 'Consistent?'.
Most of the properties are optional and have sane defaults, so they are only recommended for customized installs.

### pdns_authoritative_install

Installs PowerDNS authoritative server 4.X series using PowerDNS official repository in the supported platforms.

#### Properties

| Name          | Class       |  Default value |
|---------------|-------------|----------------|
| version       | String, nil | nil            |
| debug         | true, false | false          |

#### Usage example

Install a PowerDNS authoritative server package named `server-01` with the latest version available in the repository.

```
pdns_authoritative_install 'server_01' do
  action :install
end
```

### pdns_authoritative_config

Creates a PowerDNS recursor configuration, there is a fixed set of required properties (listed below) but most of the configuration is left to the user freely, every property set in the `variables` hash property will be rendered in the config template. Remember that using underscores `_` for property names is required and it's translated to hyphens `-` in configuration templates.

#### Properties

| Name           | Class      |  Default value  | Consistent? |
|----------------|------------|-----------------|-------------|
| instance_name  | String     | name_property   | Yes         |
| launch         | Array, nil | ['bind']        | No          |
| config_dir     | String     | see `default_authoritative_config_directory` helper method | Yes |
| socket_dir     | String     | "/var/run/#{resource.instance_name}" | Yes |
| run_group      | String     | see `default_authoritative_run_user` helper method  | No |
| run_user       | String     | see `default_authoritative_run_user` helper method  | No |
| run_user_home  | String     | see `default_user_attributes` helper method | No |
| run_user_shell | String     | see `default_user_attributes` helper method | No |
| setuid         | String     | resource.run_user | No |
| setgid         | String     | resource.run_group | No |
| source         | String,nil | 'authoritative_service.conf.erb' | No |
| cookbook       | String,nil | 'pdns' | No |
| variables      | Hash       | { bind_config:  "#{resource.config_dir}/bindbackend.conf" } | No |

#### Usage Example

Create a PowerDNS authoritative configuration file named `server-01`:

```
pdns_authoritative_config 'server_01' do
  action :create
  launch ['gpgsql']
  variables(
    gpgsql_host: '127.0.0.1',
    gpgsql_user: 'pdns',
    gpgsql_port: 5432,
    gpgsql_dbname: 'pdns',
    gpgsql_password: 'wadus',
    allow_axfr_ips: [ '127.0.0.0/8', '::1', '195.234.23,34'],
    api: true,
    api-_eadonly: true
    )
end
```

### pdns_authoritative_service

Creates a init service to manage a PowerDNS authoritative instance. This service supports all the regular actions (start, stop, restart, etc.). Check the compatibility section to see which init services are supported.

*Important:* services are not restarted or reloaded automatically on config changes in this cookbook, you need to add this in your wrapper cookbook if you desire this functionality, the `pdns_authoritative_service` cookbook provides actions to do it.

#### Properties

| Name           | Class       |  Default value                                             | Consistent? |
|----------------|-------------|------------------------------------------------------------|-------------|
| instance_name  | String      | name_property                                              | Yes         |
| cookbook       | String      | 'pdns'                                                     | No          |
| source         | String      | 'authoritative.init.debian.erb'                            | No          |
| config_dir     | String      | See `default_authoritative_config_directory` helper method | Yes         |
| socket_dir     | String      | "/var/run/#{instance_name}"                                | Yes         |
| variables      | Hash        | {}                                                         | No          |

#### Usage example

```
pdns_authoritative_service 'server_01' do
  action [:enable, :start]
end
```

### pdns_recursor_install

Installs PowerDNS recursor 4.X series using PowerDNS official repository in the supported platforms.

#### Properties

| Name           | Class       |  Default value  | Consistent? |
|----------------|-------------|-----------------|-------------|
| version        | String      | name_property   | Yes         |
| debug          | True, False | String, nil     | No          |

#### Usage Example

Install a 4. powerdns instance named 'my_recursor' on ubuntu 14.04:

    pdns_recursor_install 'my_recursor' do
      version '4.0.4-1pdns.trusty'
    end

### pdns_recursor_service

Sets up a PowerDNS recursor instance using the appropiate init system .

*Important:* services not restarted or reloaded automatically on config changes in this cookbook, you need to add this in your wrapper cookbook if you desire this functionality, the `pdns_recursor_service` cookbook provides actions to do it.


#### Properties

| Name           | Class      |  Default value                                        | Consistent? |
|----------------|------------|-------------------------------------------------------|-------------|
| instance_name  | String     | name_property                                         | Yes         |
| config_dir     | String     | see `default_recursor_config_directory` helper method | Yes         |
| cookbook (SysVinit)      | String,nil | 'pdns'                                                | No          |
| source  (SysVinit)       | String,nil | 'recursor.init.#{node['platform_family']}.erb'                            | No          |
| variables (SysVinit)    | Hash     | {} | No     |

- `config_dir`: Path of the recursor configuration directory.
- `cookbook`: Cookbook for a custom configuration template (Applied only when using SysVinit).
- `source`: Name of the recursor custom template (Applied only when using SysVinit).
- `variables`: Variables hash to pass to the sysvinit template

#### Usage Example

Configure a PowerDNS recursor service instance named 'my_recursor' in your wrapper cookbook for Acme Corp with a custom template named `my-recursor.erb`

    pdns_recursor_service 'my_recursor' do
      source 'my-recursor.erb'
      cookbook 'acme-pdns-recursor'
    end

### pdns_recursor_config

Creates a PowerDNS recursor configuration.

#### Properties

|           | Name           | Class       |  Default value                                         | Consistent? |
|----------------|-------------|--------------------------------------------------------|-------------|
| instance_name  | String      | name_property                                          | Yes         |
| config_dir     | String      | see `default_recursor_config_directory` helper method  | Yes         |
| socket_dir     | String      | /var/run/#{resource.instance_name}                     | Yes         |
| run_group      | String      | see `default_recursor_run_user` helper method          | No          |
| run_user       | String      | see `default_recursor_run_user` helper method          | No          |
| run_user_home  | String      | see `default_user_attributes` helper method            | No          |
| run_user_shell | String      | see `default_user_attributes` helper method            | No          |
| setuid         | String      | resource.run_user                                      | No          |
| setgid         | String      | resource.run_group                                     | No          |
| source         | String, nil | 'recursor_service.conf.erb'                            | No          |
| cookbook       | String, nil | 'pdns'                                                 | No          |
| variables      | Hash        | {}                                                     | No          |

- `config_dir` (C): Path of the recursor configuration directory.
- `socket_dir` (C): Directory where sockets are created.
- `source` (C): Name of the recursor custom template.
- `socket_dir` (C): Directory where sockets are created.
- `cookbook` (C): Cookbook for a custom configuration template
- `variables`: Variables for the configuration template.
- `run_group`: Unix group that runs the recursor.
- `run_user`: Unix user that runs the recursor.
- `run_user_home`: Home of the Unix user that runs the recursor.
- `run_user_shell`: Shell of the Unix user that runs the recursor.

#### Usage Example

Create a PowerDNS recursor configuration named 'my_recursor' in your wrapper cookbook for Acme Corp which uses a custom template named `my-recursor.erb` and a few attributes:

    pdns_recursor_config 'my_recursor' do
      source 'my-recursor.erb'
      cookbook 'acme-pdns-recursor'
      variables(client-tcp-timeout: '20', loglevel: '5', network-timeout: '2000')
    end

#### Virtual Hosting

PowerDNS supports virtual hosting: running many instances of PowerDNS on different ports on the same machine. This is done by a few clever hacks on the init scripts that allow to specify different config files for each instance. This cookbook leverages this functionality in both recursor and authoritative.

[PowerDNS recommends a specific naming schema](https://doc.powerdns.com/md/authoritative/running/) authoritative for virtual hosting. Specifically it does not allow hyphens (-) on the init scripts beyond the first which is provided by the init script (`/etc/init.d/pdns-`).

We have adopted the convention of using underscores (_) in the name attributes of underscores in order to comply with this requirement.

## Contributing

There is an specific file for contributing guidelines on this cokbook: CONTRIBUTING.md

## Testing

There is an specific file for testing guidelines on this cokbook: TESTING.md


License & Authors
-----------------
- Author:: Aaron Kalin (<aaron.kalin@dnsimple.com>)
- Author:: Amy Aronsohn (<amy.aronsohn@dnsimple.com>)
- Author:: Jacobo García (<jacobo.garcia@dnsimple.com>)
- Author:: Anthony Eden (<anthony.eden@dnsimple.com>)

```text
Copyright:: 2010-2014, Chef Software, Inc & 2014-2018 DNSimple Corp.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
