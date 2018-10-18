describe DonkeyClient::Services::AssignAlternative do
  subject do
    described_class.execute(experiment_slug, anonymous_user_id, user_id, cache, is_bot)
  end

  let(:experiment_slug) { 'exp_slug' }
  let(:anonymous_user_id) { 'auid123' }
  let(:user_id) { nil }
  let(:cache) { Donkey::ThreadCache }
  let(:cache_key) { "donkey/#{experiment_slug}/#{anonymous_user_id}/#{user_id}" }

  context 'when user is bot' do
    let(:is_bot) { true }

    before do
      allow_any_instance_of(::Donkey::Settings).to receive(:always_control_group?).and_return(false)
      allow_any_instance_of(described_class).to receive(:control_group).and_return('control_group')
    end

    it 'returns control group alternative' do
      expect(subject).to eq('control_group')
    end
  end

  context 'when user is not bot' do
    let(:is_bot) { false }

    before do
      allow_any_instance_of(::Donkey::Settings).to receive(:always_control_group?).and_return(false)
      allow_any_instance_of(described_class).to receive(:response_body).and_return(response_body_hash)
      allow_any_instance_of(described_class).to receive(:control_group).and_return('control_group')
    end

    context 'when cache is empty' do
      before { cache.clear }

      context 'when response body contains data with alternative slug' do
        let(:response_body_hash) { { 'data' => 'alternative' } }

        it 'returns assigned alternative' do
          expect(subject).to eq('alternative')
        end

        it 'writes data to cache' do
          expect { subject }.to change { cache.read(cache_key) }.from(nil).to('alternative')
        end

        it 'requests data from `donkey_dashboard`' do
          expect_any_instance_of(described_class).to receive(:response_body)
          subject
        end
      end
    end

    context 'when cache contains alternative for given key' do
      before { cache.write(cache_key, 'alternative') }

      context 'when response body contains data with alternative slug' do
        let(:response_body_hash) { { 'data' => 'alternative' } }

        it 'returns assigned alternative' do
          expect(subject).to eq('alternative')
        end

        it 'does not write data to cache' do
          expect(cache).not_to receive(:write)
          subject
        end

        it 'does not request data from `donkey_dashboard`' do
          expect_any_instance_of(described_class).not_to receive(:response_body)
          subject
        end
      end
    end

    context 'when response is empty' do
      before { cache.clear }

      let(:response_body_hash) { {} }

      it 'returns assigned alternative' do
        expect(subject).to eq('control_group')
      end

      it 'notifies about missing data' do
        expect(Donkey).to receive(:notify).with(instance_of(KeyError))
        subject
      end

      it 'does not write data to cache' do
        expect(cache).not_to receive(:write)
        subject
      end
    end
  end

  context 'always_control_group is set to true' do
    let(:is_bot) { false }
    let(:is_always_control_group) { true }

    before do
      cache.clear
      allow_any_instance_of(::Donkey::Settings).to receive(:always_control_group?).and_return(true)
      allow_any_instance_of(described_class).to receive(:control_group).and_return('control_group')
    end

    it 'returns control group alternative' do
      expect(subject).to eq('control_group')
    end
  end
end
