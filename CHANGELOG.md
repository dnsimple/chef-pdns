# 1.1.0 / 2015-03-25

### Enhancements

* Recursor is now the default behavior
* Adding a new slave PowerDNS server configuration
* Refactor of authoritative part
* Refactor of build related code
* Expanded documentation

# 1.0.1 / 2014-12-17

### Bug Fixes

* Adding missing configuration bits for authoritative_package recipe

# 1.0.0 / 2014-12-15

### Breaking Changes

* There have been major changes to the recipes and attributes of this
  cookbook in the first of many efforts to stabilize and modernize everything.
  Please review the updated README and take special note of the install type
  and backend attributes to suit your configuration.

* We plan to eventually migrate the recipes over to LWRP's to make this
  cookbook easier to wrap and extend.

# 0.3.4 / 2014-07-15

### Testing

* Testing Updates

### Bug Fixes

* Fixed missing build-essential include

# 0.3.3 / 2014-07-15

### Bug Fixes

* Not actually sure what happened here

# 0.3.2 / 2014-07-14

### Bug Fixes

* Remove incorrect search domains

# 0.3.0 / 2014-02-21

### Bug Fixes

* DNS should install the sqlite gem (needs build-essentials) and use the correct pdns template filename [COOK-978]

# 0.2.0 / 2013-08-28

### Improvements

* Add source recipe [COOK-3106]

# 0.1.2 / 2013-05-07

### Bug Fixes

* pdns cookbook has foodcritic failures [COOK-2986]

### Improvements

* Configure a PowerDNS server [COOK-2604]

# 0.1.0

### Initial Release

- Fixes for centos/rhel boxen and pdns::recursor cookbook [COOK-1080]
