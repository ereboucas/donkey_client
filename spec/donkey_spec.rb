describe Donkey do
  subject { described_class }

  describe '.configurate' do
    it { expect { |b| subject.configurate(&b) }.to yield_with_args(Donkey::Settings) }
  end

  describe '.configuration_data' do
    context 'when configuration is set' do
      let(:mock_data) { { 'mock_data' => nil } }

      before do
        allow(DonkeyClient::Resource::Configuration).to(receive_messages(create: mock_data))

        Donkey::Settings.configuration = mock_data
      end

      it { expect(subject.configuration_data).to eq(mock_data) }
    end
  end

  describe '.notify' do
    context 'without notifier setting' do
      it { expect(subject.notify('test')).to be_nil }
    end

    context 'with notifier setting' do
      before do
        Donkey.configurate { |config| config.notifier :donkey, :eql? }
      end

      it 'constantizes class and passes configured method with parameter' do
        expect(subject.notify(Donkey)).to eq(true)
      end
    end
  end
end
