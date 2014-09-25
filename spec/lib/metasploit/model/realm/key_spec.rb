require 'spec_helper'

describe Metasploit::Model::Realm::Key do
  context 'CONSTANTS' do
    context 'ACTIVE_DIRECTORY_DOMAIN' do
      subject(:active_directory_domain) do
        described_class::ACTIVE_DIRECTORY_DOMAIN
      end

      it { should == 'Active Directory Domain' }
      it { should be_in described_class::ALL }
    end

    context 'ALL' do
      subject(:all) do
        described_class::ALL
      end

      it { should include described_class::ACTIVE_DIRECTORY_DOMAIN }
      it { should include described_class::ORACLE_SYSTEM_IDENTIFIER }
      it { should include described_class::POSTGRESQL_DATABASE }
      it { should include described_class::WILDCARD }
    end

    context 'ORACLE_SYSTEM_IDENTIFIER' do
      subject(:oracle_system_identifier) do
        described_class::ORACLE_SYSTEM_IDENTIFIER
      end

      it { should == 'Oracle System Identifier' }
      it { should be_in described_class::ALL }
    end

    context 'POSTGRESQL DATABASE' do
      subject(:postgresql_database) do
        described_class::POSTGRESQL_DATABASE
      end

      it { should == 'PostgreSQL Database' }
      it { should be_in described_class::ALL }
    end

    context 'WILDCARD' do
      subject(:wildcard) do
        described_class::WILDCARD
      end

      it { should == '*' }
      it { should be_in described_class::ALL }
    end

    context 'SHORT_NAMES' do
      subject { described_class::SHORT_NAMES }
      it 'should have String keys' do
        subject.keys.each { |key|
          key.should be_a(String)
        }
      end
      context 'values' do
        subject { described_class::SHORT_NAMES.values.sort }
        it { should match_array(described_class::ALL.sort) }
      end
    end
  end
end
