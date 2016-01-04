source 'https://api.berkshelf.com'

metadata

group :development do
  cookbook 'postgresql'
end

group :integration do
  cookbook 'apt'
  cookbook 'pdns_test', path: './test/fixtures/cookbooks/pdns_test/'
end
