# Changelog

## [v8.0.3](https://github.com/dnsimple/chef-pdns/tree/v8.0.3) (2021-06-07)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v6.1.1...v8.0.3)

**Fixed bugs:**

- Getting an error if I do not stop pdns service [\#88](https://github.com/dnsimple/chef-pdns/issues/88)
- issue in running the test recipe [\#83](https://github.com/dnsimple/chef-pdns/issues/83)
- pdns\_authoritative\_backend matchers should be named install\_pdns\_authoritative\_backend [\#68](https://github.com/dnsimple/chef-pdns/issues/68)
- Add DNF / CentOS 8 - drop CentOS 6 [\#112](https://github.com/dnsimple/chef-pdns/pull/112) ([sspans](https://github.com/sspans))

**Closed issues:**

- RHEL / CentOS 8 needs work [\#111](https://github.com/dnsimple/chef-pdns/issues/111)
- Depfu Error: No dependency files found [\#109](https://github.com/dnsimple/chef-pdns/issues/109)
- CentOS 7: Cookbook doesn't upgrade pdns-recursor previously installed from EPEL Repo [\#65](https://github.com/dnsimple/chef-pdns/issues/65)
- CentOS 7 Support [\#64](https://github.com/dnsimple/chef-pdns/issues/64)

**Merged pull requests:**

- Enhancement/focal support [\#117](https://github.com/dnsimple/chef-pdns/pull/117) ([AGS4NO](https://github.com/AGS4NO))
- Update to series 44 [\#116](https://github.com/dnsimple/chef-pdns/pull/116) ([AGS4NO](https://github.com/AGS4NO))
- Fix/ci [\#114](https://github.com/dnsimple/chef-pdns/pull/114) ([AGS4NO](https://github.com/AGS4NO))
- Chef 14 testing [\#108](https://github.com/dnsimple/chef-pdns/pull/108) ([onlyhavecans](https://github.com/onlyhavecans))
- Update test matrix to run faster & add 18.04 [\#107](https://github.com/dnsimple/chef-pdns/pull/107) ([onlyhavecans](https://github.com/onlyhavecans))

## [v6.1.1](https://github.com/dnsimple/chef-pdns/tree/v6.1.1) (2018-12-08)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v6.1.0...v6.1.1)

**Merged pull requests:**

- Don't manage the default recursor service [\#106](https://github.com/dnsimple/chef-pdns/pull/106) ([martinisoft](https://github.com/martinisoft))

## [v6.1.0](https://github.com/dnsimple/chef-pdns/tree/v6.1.0) (2018-12-08)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v6.0.0...v6.1.0)

**Implemented enhancements:**

- Add modules to the install resources [\#104](https://github.com/dnsimple/chef-pdns/issues/104)
- Add backends option to Authoritative Installation resources [\#105](https://github.com/dnsimple/chef-pdns/pull/105) ([martinisoft](https://github.com/martinisoft))

## [v6.0.0](https://github.com/dnsimple/chef-pdns/tree/v6.0.0) (2018-12-06)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v5.0.0...v6.0.0)

**Merged pull requests:**

- Introduce virtual property for Recursor installs [\#103](https://github.com/dnsimple/chef-pdns/pull/103) ([martinisoft](https://github.com/martinisoft))
- Introduce virtual property for Authoriative installs [\#102](https://github.com/dnsimple/chef-pdns/pull/102) ([martinisoft](https://github.com/martinisoft))

## [v5.0.0](https://github.com/dnsimple/chef-pdns/tree/v5.0.0) (2018-11-27)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v4.4.0...v5.0.0)

**Implemented enhancements:**

- add an upgrade action to the recursor\_install\_rhel resource. [\#84](https://github.com/dnsimple/chef-pdns/pull/84) ([MattMencel](https://github.com/MattMencel))

**Merged pull requests:**

- Add 'series' property for install resources [\#101](https://github.com/dnsimple/chef-pdns/pull/101) ([martinisoft](https://github.com/martinisoft))
- Remove instance\_name from install resources [\#100](https://github.com/dnsimple/chef-pdns/pull/100) ([martinisoft](https://github.com/martinisoft))
- Campsite and cleanup cookstyle violations [\#99](https://github.com/dnsimple/chef-pdns/pull/99) ([martinisoft](https://github.com/martinisoft))
- Update dokken config and bump to Chef 13+ [\#98](https://github.com/dnsimple/chef-pdns/pull/98) ([martinisoft](https://github.com/martinisoft))
- Update Copyright [\#96](https://github.com/dnsimple/chef-pdns/pull/96) ([onlyhavecans](https://github.com/onlyhavecans))

## [v4.4.0](https://github.com/dnsimple/chef-pdns/tree/v4.4.0) (2018-03-09)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v4.3.1...v4.4.0)

**Implemented enhancements:**

- Support RHEL [\#93](https://github.com/dnsimple/chef-pdns/issues/93)
- Support RHEL [\#94](https://github.com/dnsimple/chef-pdns/pull/94) ([mengesb](https://github.com/mengesb))

## [v4.3.1](https://github.com/dnsimple/chef-pdns/tree/v4.3.1) (2018-03-08)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v4.3.0...v4.3.1)

**Fixed bugs:**

- Fix: converge suite authoritative-postgres-centos-6 [\#63](https://github.com/dnsimple/chef-pdns/issues/63)
- Testing cleanup/fixup [\#92](https://github.com/dnsimple/chef-pdns/pull/92) ([martinisoft](https://github.com/martinisoft))

**Closed issues:**

- Fix Testing [\#91](https://github.com/dnsimple/chef-pdns/issues/91)
- Configuration permissions issues [\#89](https://github.com/dnsimple/chef-pdns/issues/89)

**Merged pull requests:**

- Fix config permissions [\#90](https://github.com/dnsimple/chef-pdns/pull/90) ([onlyhavecans](https://github.com/onlyhavecans))
- Testing to chef 13 [\#87](https://github.com/dnsimple/chef-pdns/pull/87) ([onlyhavecans](https://github.com/onlyhavecans))

## [v4.3.0](https://github.com/dnsimple/chef-pdns/tree/v4.3.0) (2017-08-16)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v4.2.0...v4.3.0)

**Fixed bugs:**

- Rename default recursor configuration [\#86](https://github.com/dnsimple/chef-pdns/pull/86) ([martinisoft](https://github.com/martinisoft))

## [v4.2.0](https://github.com/dnsimple/chef-pdns/tree/v4.2.0) (2017-08-16)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v4.1.0...v4.2.0)

**Merged pull requests:**

- Move powerdns public key into cookbook [\#85](https://github.com/dnsimple/chef-pdns/pull/85) ([onlyhavecans](https://github.com/onlyhavecans))

## [v4.1.0](https://github.com/dnsimple/chef-pdns/tree/v4.1.0) (2017-08-09)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v4.0.0...v4.1.0)

**Fixed bugs:**

- Use append so that users can add to the pdns group [\#82](https://github.com/dnsimple/chef-pdns/pull/82) ([onlyhavecans](https://github.com/onlyhavecans))

**Closed issues:**

- Allow users to be appended to the `pdns` unix group [\#81](https://github.com/dnsimple/chef-pdns/issues/81)
- Drop apt and yum cookbooks [\#59](https://github.com/dnsimple/chef-pdns/issues/59)

## [v4.0.0](https://github.com/dnsimple/chef-pdns/tree/v4.0.0) (2017-08-04)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v3.5.0...v4.0.0)

**Implemented enhancements:**

- Refactor resources to match packaging configurations [\#80](https://github.com/dnsimple/chef-pdns/pull/80) ([therobot](https://github.com/therobot))

**Closed issues:**

- Add Systemd support [\#58](https://github.com/dnsimple/chef-pdns/issues/58)

## [v3.5.0](https://github.com/dnsimple/chef-pdns/tree/v3.5.0) (2017-07-13)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v3.4.1...v3.5.0)

**Merged pull requests:**

- Add systemd support for recursor and authoritative PowerDNS [\#66](https://github.com/dnsimple/chef-pdns/pull/66) ([jmauro](https://github.com/jmauro))

## [v3.4.1](https://github.com/dnsimple/chef-pdns/tree/v3.4.1) (2017-06-29)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v3.4.0...v3.4.1)

**Closed issues:**

- pdns\_recursor\_service\_sysvinit behaves different when using Vagrant or Docker as providers [\#77](https://github.com/dnsimple/chef-pdns/issues/77)
- Recursor refuses to start with custom socket-dir setting [\#74](https://github.com/dnsimple/chef-pdns/issues/74)

**Merged pull requests:**

- Stopping default recursor on debian based distros for sysvinit [\#78](https://github.com/dnsimple/chef-pdns/pull/78) ([therobot](https://github.com/therobot))
- Removing DB schema  [\#76](https://github.com/dnsimple/chef-pdns/pull/76) ([therobot](https://github.com/therobot))

## [v3.4.0](https://github.com/dnsimple/chef-pdns/tree/v3.4.0) (2017-06-27)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v3.3.2...v3.4.0)

**Merged pull requests:**

- Change Rake tasks [\#72](https://github.com/dnsimple/chef-pdns/pull/72) ([jmauro](https://github.com/jmauro))

## [v3.3.2](https://github.com/dnsimple/chef-pdns/tree/v3.3.2) (2017-06-23)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v3.3.1...v3.3.2)

**Merged pull requests:**

- Create PID directory on init start commands [\#75](https://github.com/dnsimple/chef-pdns/pull/75) ([therobot](https://github.com/therobot))

## [v3.3.1](https://github.com/dnsimple/chef-pdns/tree/v3.3.1) (2017-06-20)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v3.3.0...v3.3.1)

**Merged pull requests:**

- Fix MySQL package for Debian [\#70](https://github.com/dnsimple/chef-pdns/pull/70) ([Jamira40](https://github.com/Jamira40))

## [v3.3.0](https://github.com/dnsimple/chef-pdns/tree/v3.3.0) (2017-06-14)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v3.2.0...v3.3.0)

**Merged pull requests:**

- Fix naming schema for init scripts [\#69](https://github.com/dnsimple/chef-pdns/pull/69) ([therobot](https://github.com/therobot))

## [v3.2.0](https://github.com/dnsimple/chef-pdns/tree/v3.2.0) (2017-06-02)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v3.1.0...v3.2.0)

**Implemented enhancements:**

- Recursor systemd [\#61](https://github.com/dnsimple/chef-pdns/pull/61) ([jmauro](https://github.com/jmauro))

## [v3.1.0](https://github.com/dnsimple/chef-pdns/tree/v3.1.0) (2017-06-01)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v3.0.0...v3.1.0)

**Merged pull requests:**

- Enhance and fix matchers [\#67](https://github.com/dnsimple/chef-pdns/pull/67) ([therobot](https://github.com/therobot))

## [v3.0.0](https://github.com/dnsimple/chef-pdns/tree/v3.0.0) (2017-05-29)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v2.5.0...v3.0.0)

**Implemented enhancements:**

- Improving the way configuration options are handled [\#24](https://github.com/dnsimple/chef-pdns/issues/24)
- Authoritative Resource [\#49](https://github.com/dnsimple/chef-pdns/pull/49) ([therobot](https://github.com/therobot))
- PowerDNS recursor using Chef 12.5+ resource  [\#48](https://github.com/dnsimple/chef-pdns/pull/48) ([therobot](https://github.com/therobot))

**Fixed bugs:**

- Missing libssl-dev on source installs [\#44](https://github.com/dnsimple/chef-pdns/issues/44)

**Closed issues:**

- Add tests for multi recursor-multi [\#60](https://github.com/dnsimple/chef-pdns/issues/60)
- Add integration test for multi suits [\#57](https://github.com/dnsimple/chef-pdns/issues/57)
- Virtual hosting for recursor [\#55](https://github.com/dnsimple/chef-pdns/issues/55)
- Rename cookbook repository and update metadata/README [\#47](https://github.com/dnsimple/chef-pdns/issues/47)
- Sunset Chef 10.x and possibly 11.x support? [\#28](https://github.com/dnsimple/chef-pdns/issues/28)
- Switch to bind for the default backend [\#23](https://github.com/dnsimple/chef-pdns/issues/23)
- converge will fail on centos 6.5 [\#18](https://github.com/dnsimple/chef-pdns/issues/18)
- Refactor the use of mysql::client [\#15](https://github.com/dnsimple/chef-pdns/issues/15)

**Merged pull requests:**

- Test cleanup & fixup [\#62](https://github.com/dnsimple/chef-pdns/pull/62) ([therobot](https://github.com/therobot))
- Adding CI support via travis [\#54](https://github.com/dnsimple/chef-pdns/pull/54) ([therobot](https://github.com/therobot))

## [v2.5.0](https://github.com/dnsimple/chef-pdns/tree/v2.5.0) (2017-02-08)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v2.4.1...v2.5.0)

**Merged pull requests:**

- Upgrade to latest 3.4.11 version / 3.7.4 version [\#46](https://github.com/dnsimple/chef-pdns/pull/46) ([therobot](https://github.com/therobot))
- Adding missing dependency libssl dev on source install [\#45](https://github.com/dnsimple/chef-pdns/pull/45) ([therobot](https://github.com/therobot))
- Cleanup and campsite the cookbook [\#40](https://github.com/dnsimple/chef-pdns/pull/40) ([martinisoft](https://github.com/martinisoft))
- Docs: recursor is sometimes called resolver [\#39](https://github.com/dnsimple/chef-pdns/pull/39) ([jgoldschrafe](https://github.com/jgoldschrafe))

## [v2.4.1](https://github.com/dnsimple/chef-pdns/tree/v2.4.1) (2016-09-14)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v2.4.0...v2.4.1)

**Merged pull requests:**

- Fix authoritative downlaod link [\#38](https://github.com/dnsimple/chef-pdns/pull/38) ([onlyhavecans](https://github.com/onlyhavecans))

## [v2.4.0](https://github.com/dnsimple/chef-pdns/tree/v2.4.0) (2016-09-13)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v2.3.0...v2.4.0)

**Merged pull requests:**

- Change to make the cookbook compatible with CentOS/RHEL [\#36](https://github.com/dnsimple/chef-pdns/pull/36) ([stromp](https://github.com/stromp))

## [v2.3.0](https://github.com/dnsimple/chef-pdns/tree/v2.3.0) (2016-09-09)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v2.2.1...v2.3.0)

**Closed issues:**

- Bootstrapping fails [\#35](https://github.com/dnsimple/chef-pdns/issues/35)

**Merged pull requests:**

- Bump authoritative version due to advisory [\#37](https://github.com/dnsimple/chef-pdns/pull/37) ([onlyhavecans](https://github.com/onlyhavecans))

## [v2.2.1](https://github.com/dnsimple/chef-pdns/tree/v2.2.1) (2016-03-04)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v2.2.0...v2.2.1)

## [v2.2.0](https://github.com/dnsimple/chef-pdns/tree/v2.2.0) (2016-03-04)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v2.1.1...v2.2.0)

## [v2.1.1](https://github.com/dnsimple/chef-pdns/tree/v2.1.1) (2016-03-04)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v2.1.0...v2.1.1)

**Closed issues:**

- No pdns-server package [\#33](https://github.com/dnsimple/chef-pdns/issues/33)

## [v2.1.0](https://github.com/dnsimple/chef-pdns/tree/v2.1.0) (2016-01-11)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v2.0.0...v2.1.0)

**Merged pull requests:**

- Minimal support for a authoritative bind backend [\#32](https://github.com/dnsimple/chef-pdns/pull/32) ([therobot](https://github.com/therobot))

## [v2.0.0](https://github.com/dnsimple/chef-pdns/tree/v2.0.0) (2016-01-04)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v1.1.1...v2.0.0)

**Merged pull requests:**

- Building a recursor from source and major cleanup [\#31](https://github.com/dnsimple/chef-pdns/pull/31) ([therobot](https://github.com/therobot))

## [v1.1.1](https://github.com/dnsimple/chef-pdns/tree/v1.1.1) (2015-12-23)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v1.1.0...v1.1.1)

**Merged pull requests:**

- Cleanup, bug fixes and small improvements. [\#30](https://github.com/dnsimple/chef-pdns/pull/30) ([therobot](https://github.com/therobot))

## [v1.1.0](https://github.com/dnsimple/chef-pdns/tree/v1.1.0) (2015-12-10)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v1.0.5...v1.1.0)

**Merged pull requests:**

- Code refactor and added functionalities [\#25](https://github.com/dnsimple/chef-pdns/pull/25) ([therobot](https://github.com/therobot))

## [v1.0.5](https://github.com/dnsimple/chef-pdns/tree/v1.0.5) (2015-11-10)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v1.0.4...v1.0.5)

## [v1.0.4](https://github.com/dnsimple/chef-pdns/tree/v1.0.4) (2015-09-02)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v1.0.3...v1.0.4)

## [v1.0.3](https://github.com/dnsimple/chef-pdns/tree/v1.0.3) (2015-05-04)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v1.0.2...v1.0.3)

## [v1.0.2](https://github.com/dnsimple/chef-pdns/tree/v1.0.2) (2015-05-04)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v1.0.1...v1.0.2)

**Merged pull requests:**

- updating opscode to chef [\#26](https://github.com/dnsimple/chef-pdns/pull/26) ([someara](https://github.com/someara))

## [v1.0.1](https://github.com/dnsimple/chef-pdns/tree/v1.0.1) (2014-12-17)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v1.0.0...v1.0.1)

## [v1.0.0](https://github.com/dnsimple/chef-pdns/tree/v1.0.0) (2014-12-15)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v0.3.4...v1.0.0)

**Merged pull requests:**

- Cleanup work for the pdns cookbook [\#22](https://github.com/dnsimple/chef-pdns/pull/22) ([martinisoft](https://github.com/martinisoft))

## [v0.3.4](https://github.com/dnsimple/chef-pdns/tree/v0.3.4) (2014-07-15)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v0.3.3...v0.3.4)

**Merged pull requests:**

- Testing and Minor Updates [\#14](https://github.com/dnsimple/chef-pdns/pull/14) ([cwebberOps](https://github.com/cwebberOps))

## [v0.3.3](https://github.com/dnsimple/chef-pdns/tree/v0.3.3) (2014-07-14)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v0.3.2...v0.3.3)

## [v0.3.2](https://github.com/dnsimple/chef-pdns/tree/v0.3.2) (2014-07-14)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v0.3.0...v0.3.2)

**Merged pull requests:**

- Remove incorrect search domains [\#11](https://github.com/dnsimple/chef-pdns/pull/11) ([carolinebeauchamp](https://github.com/carolinebeauchamp))

## [v0.3.0](https://github.com/dnsimple/chef-pdns/tree/v0.3.0) (2014-02-21)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/v0.2.0...v0.3.0)

## [v0.2.0](https://github.com/dnsimple/chef-pdns/tree/v0.2.0) (2013-08-28)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/0.1.2...v0.2.0)

**Merged pull requests:**

- \[COOK-3106\] Build PowerDNS from source [\#8](https://github.com/dnsimple/chef-pdns/pull/8) ([dje](https://github.com/dje))

## [0.1.2](https://github.com/dnsimple/chef-pdns/tree/0.1.2) (2013-05-28)

[Full Changelog](https://github.com/dnsimple/chef-pdns/compare/dc4a523249d3aa8e0f6a5e145851dc459733ee53...0.1.2)

**Merged pull requests:**

- \[COOK-2986\] Fix foodcritic warnings [\#7](https://github.com/dnsimple/chef-pdns/pull/7) ([stevendanna](https://github.com/stevendanna))
- \[COOK-2604\] Configure a PowerDNS server [\#2](https://github.com/dnsimple/chef-pdns/pull/2) ([dje](https://github.com/dje))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
