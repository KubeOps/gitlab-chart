require 'aws-sdk-s3'
require 'open-uri'
require 'open3'
require 'capybara/rspec'
require 'selenium-webdriver'

def full_command(cmd)
  "kubectl exec -it #{pod_name} -- #{cmd}"
end

def sign_in
  visit '/users_sign_in'
  fill_in 'Username or email', with: 'root'
  fill_in 'Password', with: ENV['GITLAB_PASSWORD']
  click_button 'Sign in'
end

def gitlab_url
  protocol = ENV['PROTOCOL'] || 'https'
  "#{protocol}://gitlab.#{ENV['GITLAB_ROOT_DOMAIN']}"
end

def registry_url
  return "registry.#{ENV['GITLAB_ROOT_DOMAIN']}"
end

def restore_from_backup
  backup = ENV['BACKUP_TIMESTAMP'] || '0_11.0.0-pre'
  cmd = full_command("backup-utility --restore -t #{backup}")
  stdout, status = Open3.capture2e(cmd)

  return [stdout, status]
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :headless_chrome
  config.app_host = gitlab_url
end

RSpec.configure do |config|
  config.include Capybara::DSL
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def pod_name
  @pod ||= `kubectl get pod -l app=task-runner -o jsonpath="{.items[0].metadata.name}"`
end

def ensure_backups_on_object_storage
  Dir.glob('spec/fixtures/backups/*.tar') do |file_name|
    File.open(file_name, 'rb') do |file|
      ObjectStorage.put_object(
        bucket: 'gitlab-backups',
        key: "0_#{File.basename(file_name)}",
        body: file
      )
    end
    puts "Uploaded #{file_name}"
  end
end

if ENV['S3_CONFIG_PATH']
  s3_access_key = File.read("#{ENV['S3_CONFIG_PATH']}/accesskey")
  s3_secret_key = File.read("#{ENV['S3_CONFIG_PATH']}/secretkey")
end

s3_access_key ||= ENV['S3_ACCESS_KEY']
s3_secret_key ||= ENV['S3_SECRET_KEY']

conf = {
  region: ENV['S3_REGION'] || 'us-east-1',
  access_key_id: s3_access_key,
  secret_access_key: s3_secret_key,
  endpoint: ENV['S3_ENDPOINT'],
  force_path_style: true
}

ObjectStorage = Aws::S3::Client.new(conf)
