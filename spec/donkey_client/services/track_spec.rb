describe DonkeyClient::Services::Track do
  subject { described_class.execute(slug, anonymous_user_id, performance_increase_value, user_id, is_bot) }

  let(:slug) { 'exp_slug' }
  let(:anonymous_user_id) { 'auid123' }
  let(:performance_increase_value) { 2 }
  let(:user_id) { nil }

  context 'when user is bot' do
    let(:is_bot) { true }

    it 'does not execute tracking' do
      expect(DonkeyClient::Resource::Metric).not_to receive(:post)

      subject
    end
  end

  context 'when user is not bot' do
    let(:is_bot) { false }

    let(:query_params) do
      {
        slug: slug, anonymous_user_id: anonymous_user_id,
        performance_increase_value: performance_increase_value, user_id: user_id
      }
    end

    it 'executes tracking' do
      expect(DonkeyClient::Resource::Metric).to receive(:post).with(:track, query_params)

      subject
    end
  end
end
