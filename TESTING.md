# Testing

To run the tests across all platforms, you want to grab the latest [ChefDK][https://downloads.chef.io/tools/chefdk] or [Chef-Workstation][https://downloads.chef.io/tools/workstation] and [Docker][https://docs.docker.com/get-docker/]:

We currently use Cookstyle, ChefSpec and Inspec tests.

## ChefSpec and Cookstyle

We provide a `Rakefile` with shortcuts for running our tests.

Run: `chef exec rake` for all tests.
Run: `chef exec rake kitchen` for kitchen tests.
Run: `chef exec rake quick` for unit and style tests.

## Test-Kitchen and Inspec

Run: `chef exec kitchen list` to get a list of suites and platforms then `chef exec kitchen test <suite-platfom>` to build and verify a specific platform.
