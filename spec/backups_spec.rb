require 'spec_helper'

describe "Restoring a backup" do
  before(:all) do
    ensure_backups_on_object_storage
    cmd = full_command("backup-utility --restore -t 0_11.0.0-pre")
    stdout, status = Open3.capture2e(cmd)
    fail stdout unless status.success?
  end

  describe 'gitlab instance' do
    it 'Home page should be accessible' do
      open(gitlab_url) do |f|
        expect(f.status[0]).to eq '200'
      end
    end

    it 'Should have minimal-ruby-app repo' do
      open("#{gitlab_url}/root/minimal-ruby-app") do |f|
        expect(f.status[0]).to eq '200'
      end
    end

    it 'Should be able to clone minimal-ruby-app repo' do
      cmd = ['git', 'clone', "https://root:#{ENV['GITLAB_PASSWORD']}@#{ENV['GITLAB_DOMAIN']}/root/testproject1.git"]
      stdout, status = Open3.capture2e(*cmd)
      fail stdout unless status.success?
    end
  end
end


