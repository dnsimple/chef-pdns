# pdns Cookbook

Installs and configures PowerDNS (pdns). Sets up a recursor by default and can set up an Authoritative Server with multiple backends.

## Requirements

### Platforms:

* Ubuntu (12.04, 14.04)

### Required Cookbooks:

* build-essential (for source build)
* resolvconf (used in the server recipe for setting resolv.conf)

### Suggested Cookbooks:

* database (for configuring MySQL and Postgres users/databases)
* mysql (for the MySQL backend)
* postgres (for the PostgreSQL backend)

## Attributes

Depending on the type of server you are installing there are specific options you may want to set via attributes. Each
attribute file (other than default) corresponds to the type of PowerDNS server you are installing. This can be either
a PowerDNS recursor, or an authoritative DNS name server. The default attributes apply to both types of installations.

### default

Key                            | Type     | Description                                 | Default
-------------------------------| ---------|---------------------------------------------|---------
`node['pdns']['user']`         | String   | User to setuid the pdns daemons             | pdns
`node['pdns']['group']`        | String   | Group to setuid the pdns daemons            | pdns
`node['pdns']['build_method']` | String   | Type of installation, 'package' or 'source' | package

### authoritative

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['pdns']['authoritative']['config_dir']</tt></td>
    <td>String</td>
    <td>Path to the config directory</td>
    <td><tt>/etc/powerdns</tt></td>
  </tr>
  <tr>
    <td><tt>['pdns']['authoritative']['source']['url']</tt></td>
    <td>String</td>
    <td>URL to the PowerDNS Authoritative DNS Server Source Package</td>
    <td><tt>https://downloads.powerdns.com/releases/pdns-3.4.1.tar.bz2</tt></td>
  </tr>
  <tr>
    <td><tt>['pdns']['authoritative']['source']['path']</tt></td>
    <td>String</td>
    <td>The base path to setting up the source installation</td>
    <td><tt>/opt</tt></td>
  </tr>
  <tr>
    <td><tt>['pdns']['authoritative']['source']['backends']</tt></td>
    <td>Array</td>
    <td>List of backends to build and configure with PowerDNS</td>
    <td><tt>['gsqlite3']</tt></td>
  </tr>
  <tr>
    <td><tt>['pdns']['authoritative']['package']['backends']</tt></td>
    <td>Array</td>
    <td>List of backends to install and configure with PowerDNS via packages</td>
    <td><tt>['gsqlite3']</tt></td>
  </tr>
</table>

#### authoritative server configuration

The `['pdns']['authoritative']['config']` array directly maps to each
configuration directive in the configuration file. Of special note is
any configuration option that needs a hyphen (`-`) should be defined
as an underscore (`_`) and it will be converted at compilation time.

For example, if you want the version-string setting to be changed, you'll want
to define it like so:

`default['pdns']['authoritative']['config']['version_string'] = 'awesomedns'`

Another thing to note is boolean values are mapped to 'yes' and 'no'
respectively. If you want to remove a value, simply set it to 'nil' or do not
define the attribute entirely.

#### authoritative server backends
Each backend has its own configuration parameters, which are omitted from the PowerDNS configuration by default.  These parameters are stored in `['pdns']['authoritative'][< backend name>]`.

When the configuration file is rendered, values from the appropriate backend arroy are merged into the `['pdns']['authoritative']['config']` array.

When the gsqlite3 backend is used, this cookbook will set up the sqlite packages and database for you.  If you wish to use gmysql or gpgsql backends, it's up to you to configure the database before including the pdns::authoritative recipe.


### recursor

The `['pdns']['recursor']['config']` array directly maps to each
configuration directive in the configuration file. Of special note is
any configuration option that needs a hyphen (`-`) should be defined
as an underscore (`_`) and it will be converted at compilation time.

For example, if you want the version-string setting to be changed, you'll want
to define it like so:

`default['pdns']['recursor']['config']['local_port'] = '53'`

Another thing to note is boolean values are mapped to 'yes' and 'no'
respectively. If you want to remove a value, simply set it to 'nil' or do not
define the attribute entirely.

## Recipes

### authoritative

Sets up a PowerDNS Authoritative Server. Uses the gsqlite3 backend by default.

### authoritative_source

Sets up a PowerDNS Authoritative Server from source. This is automatically selected
based upon the `node['pdns']['build_method']` attribute.

### authoritative_package

Sets up a PowerDNS Authoritative Server from packages. This is automatically selected
based upon the `node['pdns']['build_method']` attribute. It is also the default install
method.

### recursor

Sets up a PowerDNS Recursor from packages.

## Resources

### pdns_domain

The `pdns_domain` resource creates a minimal domain definition in PowerDNS. This is made up of a domain entry, an SOA record, an NS record (required by the SOA), and an A record (required by the NS record).

Example:
```ruby
pdns_domain "example.com" do
  soa_email 'hostmaster@example.com'
  soa_ip '192.168.33.33'
end
```

Resulting domain (`dig -t axfr example.com` output):
```
example.com.            86400   IN      SOA     ns1.example.com. hostmaster.example.com. 1 10800 3600 604800 3600
example.com.            86400   IN      NS      ns1.example.com.
ns1.example.com.        120     IN      A       192.168.33.33
example.com.            86400   IN      SOA     ns1.example.com. hostmaster.example.com. 1 10800 3600 604800 3600
```

### pdns_record

The `pdns_record` resource creates a DNS record in PowerDNS.  All DNS records must be attached to an already-existing DNS domain.

Examples:
```ruby
pdns_record 'example.com.' do
  type 'MX'
  domain 'example.com'
  content 'mail.example.com'
  prio 0
end
```
```ruby
pdns_record 'mail.example.com.' do
  type 'A'
  domain 'example.com'
  content '10.0.101.11'
end
```

## Usage

To set up a Recursor, simply put `recipe[pdns::recursor]` in the run list. Modify the attributes via a role or on the node directly as required for the local configuration. If using the recursor with an Authoritative Server running on the same system, the local address and port should be changed to a public IP and the forward zones recurse setting to point at the loopback for the local zone. This is generally assumed, and the default listen interface for the recursor is set to the nodes ipaddress attribute.

To set up an authoritative server, put `recipe[pdns::authoritative]` in the run list.  To configure a backend other than SQLite, see the notes on backends above.


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
