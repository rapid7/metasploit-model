shared_examples_for 'Metasploit::Model::RealPathname' do
  context '#real_pathname' do
    subject(:real_pathname) do
      base_instance.real_pathname
    end

    before(:each) do
      base_instance.real_path = real_path
    end

    context 'with #real_path' do
      let(:real_path) do
        'real/path.rb'
      end

      it 'should be Pathname wrapping #real_path' do
        real_pathname.should == Pathname.new(real_path)
      end
    end

    context 'without #real_path' do
      let(:real_path) do
        nil
      end

      it { should be_nil }
    end
  end
end