require 'spec_helper'

describe "Restoring a backup" do
  before(:all) do
    ensure_backups_on_object_storage
    cmd = full_command("backup-utility --restore -t 0_11.0.0-pre")
    stdout, status = Open3.capture2e(cmd)
    fail stdout unless status.success?
  end

  describe 'Restored gitlab instance' do
    before { sign_in }

    it 'Home page should show projects' do
      visit '/'
      expect(page).to have_content 'Projects'
      expect(page).to have_content 'Administrator / testproject1'
    end

    it 'Navigating to testproject1 repo should work' do
      visit '/root/testproject1'
      expect(page).to have_content 'Dockerfile'
    end

    it 'Should have runner registered' do
      visit '/admin/runners'
      expect(page.all('#content-body > div > div.runners-content > div > table > tbody > tr').count).to be > 0
    end

    it 'Issue attachments should load correctly' do
      visit '/root/testproject1/issues/1'

      image_selector = '#content-body > div.issue-details.issuable-details > div.detail-page-description.content-block > div:nth-child(2) > div > div.description.js-task-list-container.is-task-list-enabled > div.wiki > p > a > img'

      expect(page).to have_selector(image_selector)
      image_src = page.evaluate_script("$('#{image_selector}')[0].src")

      open(image_src) do |f|
        expect(f.status[0]).to eq '200'
      end
    end

    it 'Could pull image from registry' do
      stdout, status = Open3.capture2e("docker login #{registry_url} --username root --password #{ENV['GITLAB_PASSWORD']}")
      expect(status.success?).to eq true
      fail "Login failed: #{stdout}" unless status.success?

      stdout, status = Open3.capture2e("#{registry_url}/root/testproject1/master:d88102fe7cf105b72643ecb9baf41a03070c9f1b")
      fail "Pulling image failed: #{stdout}" unless status.success?
    end
  end
end


