require 'spec_helper'

describe Metasploit::Model::Module::Handler do
  context 'CONSTANTS' do
    context 'GENERAL_TYPES' do
      subject(:general_types) do
        described_class::GENERAL_TYPES
      end

      it { should include 'bind' }
      it { should include 'find' }
      it { should include 'none' }
      it { should include 'reverse' }
      it { should include 'tunnel' }
    end

    context 'GENERAL_TYPE_BY_TYPE' do
      subject(:general_type_by_type) do
        described_class::GENERAL_TYPE_BY_TYPE
      end

      its(['bind_tcp']) { should == 'bind' }
      its(['find_port']) { should == 'find' }
      its(['find_shell']) { should == 'find' }
      its(['find_tag']) { should == 'find' }
      its(['none']) { should == 'none' }
      its(['reverse_http']) { should == 'tunnel' }
      its(['reverse_https']) { should == 'tunnel' }
      its(['reverse_https_proxy']) { should == 'tunnel' }
      its(['reverse_ipv6_http']) { should == 'tunnel' }
      its(['reverse_ipv6_https']) { should == 'tunnel' }
      its(['reverse_tcp']) { should == 'reverse' }
      its(['reverse_tcp_allports']) { should == 'reverse' }
      its(['reverse_tcp_double']) { should == 'reverse' }
      its(['reverse_tcp_double_ssl']) { should == 'reverse' }
      its(['reverse_tcp_ssl']) { should == 'reverse' }
    end

    context 'TYPES' do
      subject(:types) do
        described_class::TYPES
      end

      it { should include 'bind_tcp' }
      it { should include 'find_port' }
      it { should include 'find_shell' }
      it { should include 'find_tag' }
      it { should include 'none' }
      it { should include 'reverse_http' }
      it { should include 'reverse_https' }
      it { should include 'reverse_https_proxy' }
      it { should include 'reverse_ipv6_http' }
      it { should include 'reverse_ipv6_https' }
      it { should include 'reverse_tcp' }
      it { should include 'reverse_tcp_allports' }
      it { should include 'reverse_tcp_double' }
      it { should include 'reverse_tcp_double_ssl' }
      it { should include 'reverse_tcp_ssl' }
    end
  end
end