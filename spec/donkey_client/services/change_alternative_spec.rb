describe DonkeyClient::Services::ChangeAlternative do
  subject { described_class.execute(experiment_slug, alternative_slug, donkey_context) }

  let(:experiment_slug) { 'exp_slug' }
  let(:alternative_slug) { 'alt_slug' }
  let(:is_bot) { false }

  let(:donkey_context) do
    double(
      anonymous_user_id: 'auid123',
      is_bot: is_bot,
      user_id: nil,
      new_visitor: nil
    )
  end

  context 'when user is bot' do
    let(:is_bot) { true }

    before do
      subject
    end

    it 'does not call external service' do
      expect(DonkeyClient::Resource::Alternative).not_to receive(:post)
    end
  end
end
