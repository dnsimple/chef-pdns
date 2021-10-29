# PowerDNS Community Cookbook

![CI](https://github.com/dnsimple/pdns/actions/workflows/ci.yml/badge.svg)

Provides resources for installing and configuring both PowerDNS authoritative and recursor. It uses the official PowerDNS repositories for packages and installs the appropriate configuration for your platform's init system.

## Upgrade Notes for 9.x series

Please note that this version primarily supports PowerDNS 4.5 and PowerDNS Recursor 4.5. Older versions may work, but are not as heavily tested.
Support for Debian 9 has been removed from the tests as PowerDNS is not making a 4.5 repo for it.

## Upgrade Notes for 8.x series

Please note that this version primarily supports PowerDNS 4.4 and PowerDNS Recursor 4.4. Older versions may work, but are not as heavily tested. Additionally support for Ubuntu 16.04 has been dropped.

When upgrading to the 8.x series, please note that virtual recursor instances now enforce the socket directory location for compatibility with the default systemd service unit.

## Upgrade Notes for 7.x series

Please note that this version primarily supports PowerDNS 4.3 and PowerDNS Recursor 4.3. Older versions may work, but are not as heavily tested. Additionally support for CentOS 6 / sysvinit has been dropped.

When upgrading to the 7.x series, please pay special attention to your config and service resources which use the run_user / run_group / setuid / setgid properties. We have removed these attributes to better match the direction of upstream PowerDNS.

## Ubuntu >=18.04 notes

Operating systems like Ubuntu 18.04 and greater that ship with systemd-resolved configured to run by default will need this disabled and to manually configure your resolv.conf if you are running PowerDNS Authoritative on default ports.
You can look at the [test cookbook](https://github.com/dnsimple/chef-pdns/blob/master/test/cookbooks/pdns_test/recipes/disable_systemd_resolved.rb) for a simple example of how to handle this.

## Requirements

### Platforms

- Ubuntu 18.04 and newer
- Debian 9 and newer
- RHEL 7 and newer
- CentOS 7 and newer

### Chef

- Chef 15 or newer

### Init Systems

- systemd

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

#### Virtual instances and instance name

If you wish to create multiple running copies of PowerDNS via Virtual Configurations you can set the virtual property on both the config and service resources. The name of the virtual instance will default to either the name of the resource or the 'instance_name' value of the resource if it is set. PowerDNS parses the name of the instance by breaking apart the first hyphen it sees so all virtual service names start with the service type and a hyphen. For example:

```ruby
pdns_authoritative_config 'server_01' do
  virtual true
  launch ['gpgsql']
  variables(
    gpgsql_host: '127.0.0.1',
    gpgsql_user: 'pdns',
    gpgsql_port: 5432,
    gpgsql_dbname: 'pdns',
    gpgsql_password: 'wadus'
  )
  action :create
end

pdns_authoritative_service 'service_01' do
  virtual true
  action [:enable, :start]
end
```

Will create a file named `/etc/powerdns/pdns-server_01.conf`:

```shell
launch ['gpgsql']
gpgsql-host=127.0.0.1
gpgsql-user=pdns
gpgsql-port=5432
gpgsql-dbname=pdns
gpgsql-password=wadus
```

#### General note about resource properties

Most properties are simple ruby strings, but there are cases that require special attention.
Properties specified as elements in arrays will be split up (see split ruby method) and separated by commas.

Boolean properties will be always translated to 'yes' or 'no'.

Some properties need to be set consistently across resources, they will be noted in their specific sections at the top under 'Consistent?'.

Most of the properties are optional and have sane defaults, so they are only recommended for customized installs.

### pdns_authoritative_install

Installs PowerDNS authoritative server 4.4.x series using PowerDNS official repository in the supported platforms.

#### pdns_authoritative_install Properties

| Name          | Type        |  Default value |
|---------------|-------------|----------------|
| version       | String      | ''             |
| series        | String      | '44'           |
| debug         | true, false | false          |
| allow_upgrade | true, false | false          |
| backends      | Array       | nil            |

**Note:** When specifying backends, the name of the backend must match the repository package. For example, in Debian systems the Postgresql backend is actually named `pgsql` while on RHEL systems it is `postgresql`. Consider using the `value_for_platform` if you are installing on multiple platforms. There is an example of this technique in the test folder cookbook recipe.

#### pdns_authoritative_install Usage examples

Install the latest 4.4.x series PowerDNS Authoritative Server

```ruby
pdns_authoritative_install 'server_01'
```

Install the latest 4.3.x series PowerDNS Authoritative Server

```ruby
pdns_authoritative_install 'server_01' do
  series '43'
end
```

Install and upgrade to the latest 4.4.x PowerDNS Authoritative Server release

```ruby
pdns_authoritative_install 'server_01' do
  series '43'
  allow_upgrade true
end
```

Install the latest 4.4.x series PowerDNS Authoritative Server with the MySQL and Lua backends

```ruby
pdns_authoritative_install 'server_01' do
  series '44'
  backends ['mysql', 'lua']
end
```

### pdns_authoritative_config

Creates a PowerDNS authoritative configuration, there is a fixed set of required properties (listed below) but most of the configuration is left to the user freely, every property set in the `variables` hash property will be rendered in the config template. Remember that using underscores `_` for property names is required and it's translated to hyphens `-` in configuration templates.

#### pdns_authoritative_config Properties

| Name           | Class      |  Default value                                              | Consistent? |
|----------------|------------|-------------------------------------------------------------|-------------|
| instance_name  | String     | name_property                                               | Yes         |
| cookbook       | String,nil | 'pdns'                                                      | No          |
| launch         | Array, nil | ['bind']                                                    | No          |
| config_dir     | String     | see `default_authoritative_config_directory` helper method  | Yes         |
| socket_dir     | String     | "/var/run/#{resource.instance_name}"                        | Yes         |
| source         | String,nil | 'authoritative.conf.erb'                                    | No          |
| variables      | Hash       | { bind_config:  "#{resource.config_dir}/bindbackend.conf" } | No          |
| virtual        | Boolean    | false                                                       | No          |

- `cookbook` : Cookbook for a custom configuration template.
- `launch` : Backends to launch with the service.
- `config_dir` : Path of the recursor configuration directory.
- `socket_dir` : Directory where sockets are created.
- `source` : Name of the recursor custom template.
- `variables`: Variables for the configuration template.
- `virtual` : Is this a virtual instance or the default?

#### pdns_authoritative_config Usage Example

Create a PowerDNS authoritative configuration file named `server-01`:

```ruby
pdns_authoritative_config 'server_01' do
  virtual true
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
  action :create
end
```

### pdns_authoritative_service

Creates a service to manage a PowerDNS authoritative instance. This service supports all the regular actions (start, stop, restart, etc.). Check the compatibility section to see which init services are supported.

*Important:* services are not restarted or reloaded automatically on config changes in this cookbook, you need to add this in your wrapper cookbook if you desire this functionality, the `pdns_authoritative_service` cookbook provides actions to do it.

#### pdns_authoritative_service Properties

| Name           | Class       |  Default value                                             | Consistent? |
|----------------|-------------|------------------------------------------------------------|-------------|
| instance_name  | String      | name_property                                              | Yes         |
| config_dir     | String      | See `default_authoritative_config_directory` helper method | Yes         |
| virtual        | Boolean     | false                                                      | No          |

#### pdns_authoritative_service Usage example

To enable and start the default PowerDNS Authoritative server

```ruby
pdns_authoritative_service 'default' do
  action [:enable, :start]
end
```

To enable and start a virtual PowerDNS instance called 'server_01'

```ruby
pdns_authoritative_service 'server_01' do
  virtual true
  action [:enable, :start]
end
```

### pdns_recursor_install

Installs PowerDNS recursor 4.4.x series using PowerDNS official repository in the supported platforms.

#### pdns_recursor_install Properties

| Name           | Type        |  Default value  |
|----------------|-------------|-----------------|
| version        | String      | ''              |
| series         | String      | '44'            |
| debug          | true, false | false           |
| allow_upgrade  | true, false | false           |

#### pdns_recursor_install Usage examples

Install the latest 4.4.x release PowerDNS recursor

```ruby
pdns_recursor_install 'latest_4_3_x_recursor'
```

Install the latest 4.3.x release PowerDNS recursor

```ruby
pdns_recursor_install 'my_recursor' do
  series '43'
end
```

Install and upgrade to the latest 4.4.x PowerDNS recursor release

```ruby
pdns_recursor_install 'my_recursor' do
  series '44'
  allow_upgrade true
end
```

### pdns_recursor_config

Creates a PowerDNS recursor configuration.

#### pdns_recursor_config Properties

| Name           | Class      |  Default value                                              | Consistent? |
|----------------|------------|-------------------------------------------------------------|-------------|
| instance_name  | String     | name_property                                               | Yes         |
| cookbook       | String,nil | 'pdns'                                                      | No          |
| config_dir     | String     | see `default_recursor_config_directory` helper method       | Yes         |
| socket_dir     | String     | "/var/run/#{resource.instance_name}"                        | Yes         |
| source         | String,nil | 'recursor.conf.erb'                                         | No          |
| variables      | Hash       | {}                                                          | No          |
| virtual        | Boolean    | false                                                       | No          |

- `cookbook` : Cookbook for a custom configuration template.
- `config_dir` : Path of the recursor configuration directory.
- `socket_dir` : Directory where sockets are created.
- `source` : Name of the recursor custom template.
- `variables`: Variables for the configuration template.
- `virtual` : Is this a virtual instance or the default?

### pdns_recursor_service

Sets up a PowerDNS recursor instance.

*Important:* services not restarted or reloaded automatically on config changes in this cookbook, you need to add this in your wrapper cookbook if you desire this functionality, the `pdns_recursor_service` cookbook provides actions to do it.

#### pdns_recursor_service Properties

| Name           | Class       |  Default value                                             | Consistent? |
|----------------|-------------|------------------------------------------------------------|-------------|
| instance_name  | String      | name_property                                              | Yes         |
| config_dir     | String      | See `default_recursor_config_directory` helper method      | Yes         |
| virtual        | Boolean     | false                                                      | No          |

#### pdns_recursor_service Usage Examples

##### Disable the default PowerDNS recursor install service

```ruby
pdns_recursor_service 'default' do
  action [:disable, :stop]
end
```

Configure a virtual PowerDNS recursor service instance named 'my_recursor' in your wrapper cookbook for Acme Corp with a custom template named `my-recursor.erb`

```ruby
pdns_recursor_service 'my_recursor' do
  virtual true
  source 'my-recursor.erb'
  cookbook 'acme-pdns-recursor'
end
```

##### Customize the default recursor installation and change it's port to 54

```ruby
pdns_recursor_config 'default' do
  variables(
    'local-port' => '54'
  )
end
```

Create a PowerDNS recursor configuration named 'my_recursor' in your wrapper cookbook for Acme Corp which uses a custom template named `my-recursor.erb` and a few attributes:

```ruby
pdns_recursor_config 'my_recursor' do
  virtual true
  source 'my-recursor.erb'
  cookbook 'acme-pdns-recursor'
  variables(client-tcp-timeout: '20', loglevel: '5', network-timeout: '2000')
end
```

#### Virtual Hosting

PowerDNS supports virtual hosting: running many instances of PowerDNS on different ports on the same machine. This cookbook leverages this functionality in both recursor and authoritative. For recursor virtual hosts, the socket directory is strictly enforced to support the default systemd service unit.

## Contributing

There is an specific file for contributing guidelines on this cookbook: CONTRIBUTING.md

## Testing

There is an specific file for testing guidelines on this cookbook: TESTING.md

## License

Copyright (c) 2010-2014, Chef Software, Inc
Copyright (c) 2014-2021, DNSimple Corporation

Licensed under the Apache License, Version 2.0.
