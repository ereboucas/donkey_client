describe DonkeyClient::Services::AssignAlternative do
  subject { described_class.execute(experiment_slug, anonymous_user_id, user_id, cache, is_bot, always_control_group) }

  let(:experiment_slug) { 'exp_slug' }
  let(:anonymous_user_id) { 'auid123' }
  let(:cache) { Donkey::NullCache }
  let(:user_id) { nil }

  context 'when user is bot' do
    let(:is_bot) { true }
    let(:always_control_group) { false }

    before { allow_any_instance_of(described_class).to receive(:control_group).and_return('control_group') }

    it 'returns control group alternative' do
      expect(subject).to eq('control_group')
    end
  end

  context 'when user is not bot' do
    let(:is_bot) { false }
    let(:always_control_group) { false }

    before { allow_any_instance_of(described_class).to receive(:alternative).and_return('alternative') }

    it 'returns assigned alternative' do
      expect(subject).to eq('alternative')
    end
  end

  context 'always_control_group is set to true' do
    let(:is_bot) { false }
    let(:always_control_group) { true }

    before { allow_any_instance_of(described_class).to receive(:control_group).and_return('control_group') }

    it 'returns control group alternative' do
      expect(subject).to eq('control_group')
    end
  end
end
