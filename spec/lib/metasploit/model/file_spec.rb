require 'spec_helper'

describe Metasploit::Model::File do
  context 'realpath' do
    let(:real_basename) do
      'real'
    end

    let(:real_pathname) do
      Metasploit::Model::Spec.temporary_pathname.join(real_basename)
    end

    let(:symlink_basename) do
      'symlink'
    end

    let(:symlink_pathname) do
      Metasploit::Model::Spec.temporary_pathname.join(symlink_basename)
    end

    before(:each) do
      real_pathname.mkpath

      Dir.chdir(Metasploit::Model::Spec.temporary_pathname.to_path) do
        File.symlink(real_basename, 'symlink')
      end
    end

    def realpath
      described_class.realpath(symlink_pathname.to_path)
    end

    if RUBY_PLATFORM =~ /java/
      it 'should be necessary because File.realpath does not resolve symlinks' do
        File.realpath(symlink_pathname.to_path).should_not == real_pathname.to_path
      end
    end

    it 'should resolve symlink to real (canonical) path' do
      realpath.should == real_pathname.to_path
    end
  end
end