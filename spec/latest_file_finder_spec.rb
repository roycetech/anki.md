require './lib/latest_file_finder'

describe LatestFileFinder do
  context 'One level deep folder' do
    subject do
      LatestFileFinder.new('/')
    end

    it 'finds the last updated file' do
      allow(File).to receive(:mtime) do |filename|
        Time.current(2000 + filename[/\w+/][-1].to_i)
      end
      allow(Dir).to receive(:[]) { ['file1.md', 'file2. md'] }
      allow(Dir).to receive(:entries) { ['.', '..'] }
      expect(subject.find).to eq('file2. md')
    end
  end

  context 'Two level deep folder' do
    let(:separator) { File::SEPARATOR }
    let(:system_folders) { [] }

    subject do
      LatestFileFinder.new(separator)
    end

    it 'finds the last updated file, and its folder' do
      allow(File).to receive(:mtime) do |filename|
        Time.current(2000 + filename[/\w+/][-1].to_i)
      end
      allow(File).to receive(:directory?) do |args|
        args[0] == separator
      end
      allow(Dir).to receive(:[]) do |args|
        case args
        when '/*.txt' then ['file1.md', 'file2. md']
        when '/sub/*.txt' then ['file3.md', 'file4. md']
        end
      end

      allow(Dir).to receive(:entries) do |args|
        folders = ['.', '..']
        folders << 'sub' if args == separator
        folders
      end
      expect(subject.find).to eq('file4. md')
      expect(subject.last_modified_folder).to eq('/sub')
    end
  end
end
