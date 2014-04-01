require 'spec_helper'

describe package('td-agent') do
  it { should be_installed }
end

describe service('td-agent') do
  it { should be_enabled   }
  it { should be_running   }
end

describe file('/etc/td-agent/td-agent.conf') do
  it { should be_file }
end
