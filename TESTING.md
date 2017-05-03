# Testing

To run the tests across all platforms, you want to grab the latest [ChefDK][https://downloads.chef.io/chefdk],
install [VirtualBox][http://virtualbox.org], and, [Vagrant][https://www.vagrantup.com]:

We currenty use Rubocop, Foodcritic, ChefSpec and Inspec tests.

## Rubocop, Foodcritic, and ChefSpec

We provide a Rakefile with shortcuts for running our tests.

Run : `chef exec rake style:rubocop` for rubocop tests.
Run : `chef exec rake style:foodcritic` for foodcritic tests.
Run: `chef exec rake style` for both style tests.
Run: `chef exec rake unit` for unit tests.
Run: `chef exec rake quick` for unit and style tests. 

## Test-Kitchen and Inspec

Run: `chef exec kitchen list` to get a list of suites and platforms then `chef exec kitchen verify <suite-platfom>` to verify a specific platform.


