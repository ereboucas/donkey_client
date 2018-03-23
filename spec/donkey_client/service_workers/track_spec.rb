describe DonkeyClient::ServiceWorkers::Track do
  subject { described_class.perform_later(slug, anonymous_user_id, performance_increase_value, user_id, is_bot) }

  let(:slug) { 'exp_slug' }
  let(:anonymous_user_id) { 'auid123' }
  let(:performance_increase_value) { 2 }
  let(:user_id) { nil }
  let(:is_bot) { false }

  context 'with test adapter' do
    subject { described_class.perform_later(slug, anonymous_user_id, performance_increase_value, user_id, is_bot) }

    before do
      ActiveJob::Base.queue_adapter = :test
      subject
    end

    it { expect(ActiveJob::Base.queue_adapter).to be_a(ActiveJob::QueueAdapters::TestAdapter) }

    it 'does not execute the service instantly' do
      expect(DonkeyClient::Services::Track).not_to receive(:execute)
    end

    it 'enqueues the job' do
      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq(1)
    end
  end

  context 'with inline adapter' do
    subject { described_class.perform_later(slug, anonymous_user_id, performance_increase_value, user_id, is_bot) }

    before { ActiveJob::Base.queue_adapter = :inline }

    it { expect(ActiveJob::Base.queue_adapter).to be_a(ActiveJob::QueueAdapters::InlineAdapter) }

    it 'executes service instantly' do
      expect(DonkeyClient::Services::Track).to receive(:execute)

      subject
    end

    it 'executes tracking instantly' do
      expect(DonkeyClient::Resource::Metric).to receive(:post)

      subject
    end
  end
end
