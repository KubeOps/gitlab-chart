require 'aws-sdk-s3'
require 'rspec_command'
require 'inifile'
require 'open-uri'
require 'open3'



RSpec.configure do |config|
  config.include RSpecCommand
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

def full_command(cmd)
  "kubectl exec -it #{pod_name} -- #{cmd}"
end

def gitlab_url
  protocol = ENV['PROTOCOL'] || 'https'
  "#{protocol}://#{ENV['GITLAB_DOMAIN']}"
end

s3cfg=IniFile.load("#{Dir.home}/.s3cfg")["default"]

conf = {
  region: s3cfg['region'] || 'us-east-1',
  access_key_id: s3cfg['access_key'],
  secret_access_key: s3cfg['secret_key'],
  endpoint: s3cfg['website_endpoint'],
  force_path_style: true
}

ObjectStorage = Aws::S3::Client.new(conf)
