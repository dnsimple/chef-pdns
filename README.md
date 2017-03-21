# PowerDNS Community Cookbook

Provides resources for installing and configuring both PowerDNS authoritative and recursor. It uses the official PowerDNS repositories for packages and installs the appropiate configuration for your platform's init system.

## Requirements

IMPORTANT: Please read the Compatibility Notes version below since there is breaking changes between 2 and 3 versions of this cookbook.

### Compatibility Notes

**This cookbook is being completely rewritten, transitioning from an attribute centric design to a newer resource based design. The current 3.0 version the resource only supports recursors, being the authoritative server the next feature, destined for the 3.1 release which will be released soon. If you want to keep your authoritative PowerDNS installs pin your cookbook to the latest 2.5.0 version.**

### Platforms:

* Ubuntu (14.04, 16.04)
* Debian (8)
* CentOS (6.8, 7.2)

### Chef:

- Chef 12.5+

### Required Cookbooks:

* apt
* yum

### Suggested Cookbooks:

* mysql (for the MySQL backend)
* sqlite (for the SQLite backend)
* postgres (for the PostgreSQL backend)

## Usage

Use the `pdns_recursor_install`, `pdns_recursor_config`, and `pdns_recursor_service` resources in your wrapper cookbooks to install, configure, and define PowerDNS recursors. Set the different properties on the resources according to your install and configuration needs. You can see a good example on this on `test/cookbooks/pdns_test/recipes_recursor_install_single.rb`

Some properties need to set consistently accross `pdns_recursor_config` and `pdns_recursor_service`. They will be noted in their specific sections with a (C). 

Most of the properties are optional and have sane defaults, so they are only recommended for customized installs.

### pdns_recursor_install

Installs PowerDNS recursor 4.X series using PowerDNS official repository in the supported platforms.

#### Properties

- `version`: Which version is installed, defaults to the latest version available in the repository.
- `debug`: (CentOS only), installs debug-symbols from PowerDNS debug repository.

#### Usage Example

Install a 4. powerdns instance named 'my-recursor' on ubuntu 14.04:

    pdns_recursor_install 'my-recursor' do
      version '4.0.4-1pdns.trusty'
    end

### pdns_recursor_service

Sets up a PowerDNS recursor instance using the appropiate init system (SysV Init for now).

#### Properties

- `cookbook` (C): Cookbook for a custom configuration template.
- `source` (C): Name of the recursor custom template.
- `config_dir` (C): Path of the recursor configuration directory.
- `instances_dir` (C): Directory under the recursor config path that holds recursor instances.
- `socket_dir`: Directory where sockets are created.

#### Usage Example

Configure a PowerDNS recursor service instance named 'my-recursor' in your wrapper cookbook for Acme Corp with a custom template named `my-recursor.erb`

    pdns_recursor_service 'my-recursor' do
      source 'my-recursor.erb'
      cookbook 'acme-pdns-recursor'
    end

### pdns_recursor_config

Creates a PowerDNS recursor configuration.

#### Properties

- `config_dir` (C): Path of the recursor configuration directory.
- `socket_dir` (C): Directory where sockets are created.
- `instances_dir` (C): Directory under the recursor config path that holds recursor instances.
- `source` (C): Name of the recursor custom template.
- `socket_dir` (C): Directory where sockets are created.
- `cookbook` (C): Cookbook for a custom configuration template
- `variables`: Variables for the configuration template.
- `run_group`: Unix group that runs the recursor.
- `run_user`: Unix user that runs the recursor.
- `run_user_home`: Home of the Unix user that runs the recursor.
- `run_user_shell`: Shell of the Unix user that runs the recursor.

#### Usage Example

Create a PowerDNS recursor configuration named 'my-recursor' in your wrapper cookbook for Acme Corp which uses a custom template named `my-recursor.erb` and a few attributes:

    pdns_recursor_config 'my-recursor' do
      source 'my-recursor.erb'
      cookbook 'acme-pdns-recursor'
      variables(client-tcp-timeout: '20', loglevel: '5', network-timeout: '2000')
    end


License & Authors
-----------------
- Author:: Aaron Kalin (<aaron.kalin@dnsimple.com>)
- Author:: Jacobo García (<jacobo.garcia@dnsimple.com>)
- Author:: Anthony Eden (<anthony.eden@dnsimple.com>)

```text
Copyright:: 2010-2014, Chef Software, Inc & 2014-2016 Aetrion, LLC.

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
