require 'spec_helper'
require 'serverspec'

sysctl_bin = '/sbin/sysctl'
sysctl_conf = '/etc/sysctl.conf'
sysctl = {}

case os[:family]
when 'freebsd', 'openbsd'
  sysctl = {
    'net.inet.ip.forwarding' => 1,
    'kern.maxfiles' => 20000
  }
end

sysctl.each do |k, v|
  describe command("#{ sysctl_bin } -n #{ k }") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /^#{ v }$/ }
    its(:stderr) { should match /^$/ }
  end

  describe file(sysctl_conf) do
    its(:content) { should match Regexp.escape("#{ k }=#{ v }") }
  end
end
