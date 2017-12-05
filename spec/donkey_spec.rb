describe Donkey do
  subject { described_class }

  describe '.configurate' do
    it { expect { |b| subject.configurate(&b) }.to yield_with_args(Donkey::Settings) }
  end

  describe '.configuration_data' do
    context 'when api back-end is offline' do
      it { expect(subject.configuration_data).to be_falsey }
    end

    context 'when resource fetches data' do
      let(:mock_response) { { 'mock_data' => nil } }

      before do
        allow(DonkeyClient::Resource::Configuration).
          to(receive_message_chain(:last, :data, :as_json) { mock_response })
      end

      it { expect(subject.configuration_data).to eq(mock_response) }
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
