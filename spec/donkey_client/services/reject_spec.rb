describe DonkeyClient::Services::Reject do
  subject { described_class.execute(slug, anonymous_user_id, user_id, is_bot, occurred_at) }

  let(:slug) { 'exp_slug' }
  let(:anonymous_user_id) { 'auid123' }
  let(:is_bot) { false }
  let(:user_id) { nil }
  let(:occurred_at) { Time.current }

  context 'when user is bot' do
    let(:is_bot) { true }

    it 'does not execute tracking' do
      expect(DonkeyClient::Resource::Metric).not_to receive(:post)

      subject
    end
  end

  context 'when user is not bot' do
    let(:query_params) { { slug: slug, anonymous_user_id: anonymous_user_id, user_id: nil, occurred_at: occurred_at } }

    it 'executes tracking' do
      expect(DonkeyClient::Resource::Metric).to receive(:post).with(:reject, query_params)

      subject
    end
  end
end
