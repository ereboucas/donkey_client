describe DonkeyClient::Services::ChangeAlternative do
  subject do
    described_class.execute(experiment_slug, alternative_slug, anonymous_user_id, user_id, is_bot, new_visitor)
  end

  let(:experiment_slug) { 'exp_slug' }
  let(:alternative_slug) { 'alt_slug' }
  let(:is_bot) { false }
  let(:anonymous_user_id) { 'auid123' }
  let(:user_id) { nil }
  let(:new_visitor) { nil }

  let(:expected_response) { double(body: { data: alternative_slug }.to_json, code: 200) }

  context 'when user is not a bot' do
    before do
      expect(DonkeyClient::Resource::Alternative).to receive(:post) { expected_response }
    end

    it 'calls external resource and returns selected alternative slug' do
      is_expected.to eq(alternative_slug)
    end
  end

  context 'when user is bot' do
    let(:is_bot) { true }

    before do
      expect(DonkeyClient::Resource::Alternative).not_to receive(:post)
    end

    it 'does not call external resource' do
      is_expected.to be_nil
    end
  end
end
