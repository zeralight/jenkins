require 'openssl'

include_recipe 'jenkins_server_wrapper::default'

fixture_data_base_path = ::File.join(::File.dirname(Chef::Config[:config_file]), 'data')

# Test basic password credentials creation
jenkins_password_credentials 'schisamo' do
  id 'schisamo'
  description 'passwords are for suckers'
  username 'schisamo'
  password 'superseekret'
end

# Test specifying a UUID-based ID
jenkins_password_credentials '63e11302-d446-4ba0-8aa4-f5821f74d36f' do
  username 'schisamo2'
  password 'superseekret'
end

# Test specifying a string-based ID
jenkins_password_credentials 'schisamo3' do
  username 'schisamo3'
  password 'superseekret'
end

# Test basic private key credentials creation
jenkins_private_key_credentials 'jenkins' do
  id 'jenkins'
  description 'this is more like it'
  private_key lazy { File.read("#{fixture_data_base_path}/test_id_rsa") }
end

# Test private key credentials with passphrase
jenkins_private_key_credentials 'jenkins2' do
  id 'jenkins2'
  private_key lazy { OpenSSL::PKey::RSA.new(File.read("#{fixture_data_base_path}/test_id_rsa_with_passphrase"), 'secret').to_pem }
  passphrase 'secret'
end

# Test basic private key credentials creation
jenkins_private_key_credentials 'jenkins3' do
  description 'I specified an ID'
  id '766952b8-e1ea-4ee1-b769-e159681cb893'
  private_key lazy { File.read("#{fixture_data_base_path}/test_id_rsa") }
end

# Test an ECDSA key without a passphrase
jenkins_private_key_credentials 'ecdsa_nopasswd' do
  id 'ecdsa_nopasswd'
  description 'ECDSA key passed in as string'
  private_key lazy { File.read("#{fixture_data_base_path}/test_id_ecdsa") }
end

# Test an ECDSA key with a passphrase
jenkins_private_key_credentials 'ecdsa_passwd' do
  id 'ecdsa_passwd'
  description 'ECDSA key passed in as an object'
  private_key lazy { OpenSSL::PKey::EC.new(File.read("#{fixture_data_base_path}/test_id_ecdsa_with_passphrase"), 'secret').to_pem }
  passphrase 'secret'
end

# Test creating a password with a dollar sign in it
jenkins_password_credentials 'dollarbills' do
  id 'dollarbills'
  password '$uper$ecret'
end

# Plugin required for Secret Text credentials
jenkins_plugin 'plain-credentials' do
  ignore_deps_versions true
  notifies :restart, 'service[jenkins]', :immediately
end

# Test creating a secret text with a dollar sign in it
jenkins_secret_text_credentials 'dollarbills_secret' do
  id 'dollarbills_secret'
  secret '$uper$ecret'
end

# Test creating a file credentials
jenkins_file_credentials 'myfile' do
  id 'myfile'
  filename 'myfile'
  data 'mydata'
end
