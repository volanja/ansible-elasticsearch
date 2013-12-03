require 'spec_helper'

describe package('elasticsearch') do
  it { should be_installed }
end

describe service('elasticsearch') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(9300) do
  it { should be_listening }
end

describe file('/etc/elasticsearch/elasticsearch.yml') do
  it { should be_file }
  #it { should contain "ServerName default" }
end
