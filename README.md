# pdns Cookbook

Installs and configures PowerDNS (pdns). Sets up an authoritative  by default and can set up an Authoritative Server with multiple backends.

## Requirements

### Platforms:

* Ubuntu (12.04, 14.04)

### Required Cookbooks:

* build-essential (for source build)
* resolvconf (used in the server recipe for setting resolv.conf)

### Suggested Cookbooks:

* mysql (for the MySQL backend)
* sqlite (for the SQLite backend)
* postgres (for the PostgreSQL backend)

## Attributes

Depending on the type of server you are installing there are specific options you may want to set via attributes. Several attribute files handle settings of the different 'flavors' of a PowerDNS install, that is an authoritative server, a slave server or a recursor. Also there is two attribute files that handle the way PowerDNS should be installed: via a package or compiled by source.

The different combinations of install method and functionality are handled by the attributes 'build_method' and 'flavor' located in the default attributes file. You can set this attributes accordingly to your needs.

### default

Key                             | Type     | Description                                         | Default
--------------------------------| ---------|-----------------------------------------------------|---------
`node['pdns']['build_method']`  | String   | Type of installation: 'package' or 'source'         | package
`node['pdns']['flavor']`        | String   | Functionality: 'resolver', 'authoritative', 'slave' | recursor
`node['pdns']['user']`          | String   | User to setuid the pdns daemons                     | pdns
`node['pdns']['group']`         | String   | Group to setuid the pdns daemons                    | pdns


### source

Key                                 | Type     | Description                                           | Default
------------------------------------| ---------|-------------------------------------------------------|---------
`node['pdns']['source']['path']`    | String   | The base path to setting up the source installation   | /opt
`node['pdns']['source']['version']` | String   | Version of source server or resolver based on 'flavor'| 3.4.7 or 3.7.3 
`node['pdns']['source']['url']`     | String   | URL to the PowerDNS Server Source Package             | https://downloads.powerdns.com/releases/pdns-[recursor?]-[version].tar.bz2

### package

Key                                  | Type     | Description                                           | Default
-------------------------------------| ---------|-------------------------------------------------------|---------


### authoritative

Key                                                          | Type     | Description                                                      | Default
-------------------------------------------------------------|----------|------------------------------------------------------------------|---------
`node['pdns']['authoritative']['backends']`                  | Array    | List of backends to build and configure or install with PowerDNS | [ 'bind' ] 
`node['pdns']['authoritative']['config']['launch']`          | String   | Backend that will be used when running PowerDNS                  | bind
`node['pdns']['authoritative']['config']['config_dir']`      | String   | Location of configuration directory                              | /etc/powerdns
`node['pdns']['authoritative']['config']['setgid']`          | String   | User to setuid the pdns daemons                                  | pdns
`node['pdns']['authoritative']['config']['setuid']`          | String   | Group to setuid the pdns daemons                                 | pdns
`node['pdns']['authoritative']['config']['version_string']`  | String   | What powerdns answers when queried for its version over DNS      | powerdns
`node['pdns']['authoritative']['config']['allow_recursion']` | Array    | IP addresses that are authorized for recursion                   | [ '127.0.0.1' ]
`node['pdns']['authoritative']['config']['daemon']`          | Boolean  | Operate as a daemon                                              | true
`node['pdns']['authoritative']['config']['disable_axfr']`    | Boolean  | Do not allow zone transfers                                      | true
`node['pdns']['authoritative']['config']['guardian']`        | Boolean  | Run within a guardian process                                    | true
`node['pdns']['authoritative']['config']['default_ttl']`     | String   | TTL to use when none is provided                                 | 3600

### slave

Key                                                           | Type     | Description                                                       | Default
--------------------------------------------------------------|----------|-------------------------------------------------------------------|---------
`node['pdns']['slave']['backends']`                           | Array    | List of backends to build and configure or install with PowerDNS  | [ 'bind' ] 
`node['pdns']['slave']['config']['launch']`                   | String   | Backend that will be used when running PowerDNS                   | bind
`node['pdns']['slave']['config']['config_dir']`               | String   | Location of configuration directory                               | /etc/powerdns
`node['pdns']['slave']['config']['setgid']`                   | String   | User to setuid the pdns daemons                                   | pdns
`node['pdns']['slave']['config']['setuid']`                   | String   | Group to setuid the pdns daemons                                  | pdns
`node['pdns']['slave']['config']['version_string']`           | String   | What powerdns answers when queried for its version over DNS       | powerdns
`node['pdns']['slave']['config']['master']`                   | Boolean  | Operate in master mode                                            | false
`node['pdns']['slave']['config']['slave']`                    | Boolean  | Operate as a slave to a PowerDNS master server                    | true
`node['pdns']['authoritative']['config']['guardian']`        | Boolean  | Run within a guardian process                                    | true
`node['pdns']['slave']['config']['slave_cycle_interval']`     | String   | Seconds slave checks of domains with unknown status               | '60'
`node['pdns']['slave']['config']['disable_axfr']`             | Boolean  | Do not allow zone transfers                                       | true

### recursor

Key                                                           | Type     | Description                                                       | Default
--------------------------------------------------------------|----------|-------------------------------------------------------------------|---------
`node['pdns']['recursor']['config_dir']`                      | String   | Location of configuration directory                               | /etc/powerdns
`node['pdns']['recursor']['config']['config_dir']`            | String   | Location of configuration directory                               | /etc/powerdns
`node['pdns']['recursor']['config']['allow_from']`            | Array    | Netmasks that are allowed to use the server                       | '127.0.0.0/8', '10.0.0.0/8', '192.168.0.0/16', '172.16.0.0/12', '::1/128', 'e80::/10'
`node['pdns']['recursor']['config']['auth_zones']`            | Array    | Zones read from these files are served authoritatively            | [ ]
`node['pdns']['recursor']['config']['forward_zones']`         | Array    | Queries for zones listed here will be forwarded to the IP         | [ ]
`node['pdns']['recursor']['config']['forward_zones_recurse']` | Array    | Add the recurse bit to the behavior of forward zones              | [ ]
`node['pdns']['recursor']['config']['local_address']`         | Array    | IP addresses to bind to                                           | ['127.0.0.1']
`node['pdns']['recursor']['config']['local_port']`            | String   | Port to listen                                                    | '53'

## Further configurations

Every flavor has it's own attribute namespace for customizing it. More precisely

The `['pdns'][flavor]['config']` array directly maps to each
configuration directive in the configuration file. Of special note is
any configuration option that needs a hyphen (`-`) should be defined
as an underscore (`_`) and it will be converted at compilation time.

For example, if you want the version-string setting to be changed for your 
authoritative server, you'll want to define it like so:

`default['pdns']['authoritative']['config']['version_string'] = 'awesomedns'`

Another thing to note is boolean values are mapped to 'yes' and 'no'
respectively. If you want to remove a value, simply set it to 'nil' or do not
define the attribute entirely.

## Usage

Add the default recipe and set the right attributes ('flavor' and 'install_method') to install and configure PowerDNS as your needs. The default behavior is installing a recursor by package.

To set up a secursor, simply put `recipe[pdns::default]` in the run list. Modify the attributes via a role or on the node directly as required for the local configuration. 

To set up an authoritative server, put `recipe[pdns::default]` in the run list and set the attribute `node['pdns']['flavor']` to 'authoritative'. If another backend besides SQLite is desired, change the `node['pdns']['server']['backend']` attribute. Choose between 'package', 'source' with the `node['pdns']['install_method']` attribute. Tune your server specific configuration with `node['pdns']['authoritative']['config']`.

To set up an slave server, add `recipe[pdns::default]` to you run list and set the attribute `node['pdns']['flavor']` to 'slave'. Choose between 'package', 'source' with the `node['pdns']['install_method']` attribute. Tune your server specific configuration with `node['pdns']['slave']['config']`.

### Notes

 - Ubuntu has an specific database configuration when using their packges for backends, it's located here: `/etc/powerdns/pdns.d/`
 - It is not possible to install both an authoritative server and a recursor on the same machine using the flavor attribute.

## TODO

 - Add MySQL backend
 - Add SQLite backend
 - Use ubuntu `/etc/powerdns/pdns.d/` for configuring PowerDNS.

License & Authors
-----------------
- Author:: Joshua Timberman (<joshua@chef.io>)
- Author:: Aaron Kalin (<aaron.kalin@dnsimple.com>)
- Author:: Jacobo García (<jacobo.garcia@dnsimple.com>)
- Author:: Anthony Eden (<anthony.eden@dnsimple.com>)

```text
Copyright:: 2010-2014, Chef Software, Inc & 2014 Aetrion, LLC.

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
