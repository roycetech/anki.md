require './bin/upload'
require './bin/main_script'

describe 'main_script' do
  context 'unit testing' do
    it 'does not run selenium' do
      expect(RunSelenium).not_to receive(:execute)
    end

    it 'does not run file finder' do
    end
  end
end
