require 'spec_helper'
require 'ansible_spec'
require 'yaml'

set :backend, :ssh

describe 'ssh' do
  context 'with root user' do 
    before do
      create_normality
      properties = AnsibleSpec.get_properties
      @h = Hash.new
      n = 0
      properties.each do |property|
        property["hosts"].each do |host|
          #ENV['TARGET_PRIVATE_KEY'] = '~/.ssh/id_rsa'
          #t.pattern = 'roles/{' + property["roles"].join(',') + '}/spec/*_spec.rb'
          @ssh = double(:ssh)
          if host.instance_of?(Hash)
            set :host, host["uri"]
            unless host["user"].nil?
              user = host["user"]
            else
              user = property["user"]
            end
            set :ssh_options, :user => user, :port => host["port"], :keys => host["private_key"]
            allow(@ssh).to receive(:port).and_return(Specinfra.configuration.ssh_options[:port])
            allow(@ssh).to receive(:keys).and_return(Specinfra.configuration.ssh_options[:keys])
          else
            set :host, host
            set :ssh_options, :user => property["user"]
          end
          allow(@ssh).to receive(:host).and_return(Specinfra.configuration.host)
          allow(@ssh).to receive(:user).and_return(Specinfra.configuration.ssh_options[:user])
          @h["task_#{n}"] = @ssh
          n += 1
        end
      end
    end

    it '192.168.0.1' do
      v = @h["task_0"]
      expect(v.user).to eq 'root'
      expect(v.host).to eq '192.168.0.1'
    end
    it '192.168.0.2:22' do
      v = @h["task_1"]
      expect(v.user).to eq 'root'
      expect(v.host).to eq '192.168.0.2'
      expect(v.port).to eq 22
    end
    it '192.168.0.3 ansible_ssh_port=22' do
      v = @h["task_2"]
      expect(v.user).to eq 'root'
      expect(v.host).to eq '192.168.0.3'
      expect(v.port).to eq 5309
    end
    it '192.168.0.4 ansible_ssh_private_key_file=~/.ssh/id_rsa' do
      v = @h["task_3"]
      expect(v.user).to eq 'root'
      expect(v.host).to eq '192.168.0.4'
      expect(v.port).to eq 22
      expect(v.keys).to eq '~/.ssh/id_rsa'
    end

    it '192.168.0.5 ansible_ssh_user=git' do
      v = @h["task_4"]
      expect(v.user).to eq 'git'
      expect(v.host).to eq '192.168.0.5'
      expect(v.port).to eq 22
    end

    it 'jumper ansible_ssh_port=5555 ansible_ssh_host=192.168.1.50' do
      v = @h["task_5"]
      expect(v.user).to eq 'root'
      expect(v.host).to eq '192.168.1.50'
      expect(v.port).to eq 5555
    end

    it 'www[01:02].example.com' do
      v = @h["task_6"]
      expect(v.user).to eq 'root'
      expect(v.host).to eq 'www01.example.com'
    end

    it 'www[01:02].example.com' do
      v = @h["task_7"]
      expect(v.user).to eq 'root'
      expect(v.host).to eq 'www02.example.com'
    end

    it 'db-[a:b].example.com' do
      v = @h["task_8"]
      expect(v.user).to eq 'root'
      expect(v.host).to eq 'db-a.example.com'
    end

    it 'db-[a:b].example.com' do
      v = @h["task_9"]
      expect(v.user).to eq 'root'
      expect(v.host).to eq 'db-b.example.com'
    end

    after do
      delete_normality
    end
  end

  context 'without root user' do
    before do
      create_without_user
      properties = AnsibleSpec.get_properties
      @h = Hash.new
      n = 0
      properties.each do |property|
        property["hosts"].each do |host|
          #ENV['TARGET_PRIVATE_KEY'] = '~/.ssh/id_rsa'
          #t.pattern = 'roles/{' + property["roles"].join(',') + '}/spec/*_spec.rb'
          @ssh = double(:ssh)
          if host.instance_of?(Hash)
            set :host, host["uri"]
            unless host["user"].nil?
              user = host["user"]
            else
              user = property["user"]
            end
            set :ssh_options, :user => user, :port => host["port"], :keys => host["private_key"]
            allow(@ssh).to receive(:port).and_return(Specinfra.configuration.ssh_options[:port])
            allow(@ssh).to receive(:keys).and_return(Specinfra.configuration.ssh_options[:keys])
          else
            set :host, host
            set :ssh_options, :user => property["user"]
          end
          allow(@ssh).to receive(:host).and_return(Specinfra.configuration.host)
          allow(@ssh).to receive(:user).and_return(Specinfra.configuration.ssh_options[:user])
          @h["task_#{n}"] = @ssh
          n += 1
        end
      end
    end

    it '192.168.0.1' do
      v = @h["task_0"]
      expect(v.user).to eq ENV['USER']
      expect(v.host).to eq '192.168.0.1'
    end

    it '192.168.0.5 ansible_ssh_user=git' do
      v = @h["task_1"]
      expect(v.user).to eq 'git'
      expect(v.host).to eq '192.168.0.5'
      expect(v.port).to eq 22
    end

    after do
      delete_normality
    end
  end

  context 'without root user. but ansible.cfg exist' do
    before do
      create_without_user
      create_ansible_cfg
      properties = AnsibleSpec.get_properties
      @h = Hash.new
      n = 0
      properties.each do |property|
        property["hosts"].each do |host|
          #ENV['TARGET_PRIVATE_KEY'] = '~/.ssh/id_rsa'
          #t.pattern = 'roles/{' + property["roles"].join(',') + '}/spec/*_spec.rb'
          @ssh = double(:ssh)
          if host.instance_of?(Hash)
            set :host, host["uri"]
            unless host["user"].nil?
              user = host["user"]
            else
              user = property["user"]
            end
            set :ssh_options, :user => user, :port => host["port"], :keys => host["private_key"]
            allow(@ssh).to receive(:port).and_return(Specinfra.configuration.ssh_options[:port])
            allow(@ssh).to receive(:keys).and_return(Specinfra.configuration.ssh_options[:keys])
          else
            set :host, host
            set :ssh_options, :user => property["user"]
          end
          allow(@ssh).to receive(:host).and_return(Specinfra.configuration.host)
          allow(@ssh).to receive(:user).and_return(Specinfra.configuration.ssh_options[:user])
          @h["task_#{n}"] = @ssh
          n += 1
        end
      end
    end

    it '192.168.0.1' do
      v = @h["task_0"]
      expect(v.user).to eq 'root'
      expect(v.host).to eq '192.168.0.1'
    end

    it '192.168.0.5 ansible_ssh_user=git' do
      v = @h["task_1"]
      expect(v.user).to eq 'git'
      expect(v.host).to eq '192.168.0.5'
      expect(v.port).to eq 22
    end

    after do
      delete_normality
      delete_ansible_cfg
    end
  end
end

def create_normality
  tmp_ansiblespec = '.ansiblespec'
  tmp_playbook = 'site.yml'
  tmp_hosts = 'hosts'

  content = <<'EOF'
---
-
  playbook: site.yml
  inventory: hosts
EOF

  content_p = <<'EOF'
- name: Ansible-Sample-TDD
  hosts: normal
  user: root
  roles:
    - nginx
    - mariadb
EOF

  content_h = <<'EOF'
[normal]
192.168.0.1
192.168.0.2 ansible_ssh_port=22
192.168.0.3:5309
192.168.0.4 ansible_ssh_private_key_file=~/.ssh/id_rsa
192.168.0.5 ansible_ssh_user=git
jumper ansible_ssh_port=5555 ansible_ssh_host=192.168.1.50
www[01:02].example.com
db-[a:b].example.com
EOF

  File.open(tmp_ansiblespec, 'w') do |f|
    f.puts content
  end
  File.open(tmp_playbook, 'w') do |f|
    f.puts content_p
  end
  File.open(tmp_hosts, 'w') do |f|
    f.puts content_h
  end
end

def create_without_user
  tmp_ansiblespec = '.ansiblespec'
  tmp_playbook = 'site.yml'
  tmp_hosts = 'hosts'

  content = <<'EOF'
---
-
  playbook: site.yml
  inventory: hosts
EOF

  content_p = <<'EOF'
- name: Ansible-Sample-TDD
  hosts: normal
  roles:
    - nginx
    - mariadb
EOF

  content_h = <<'EOF'
[normal]
192.168.0.1
192.168.0.5 ansible_ssh_user=git
EOF

  File.open(tmp_ansiblespec, 'w') do |f|
    f.puts content
  end
  File.open(tmp_playbook, 'w') do |f|
    f.puts content_p
  end
  File.open(tmp_hosts, 'w') do |f|
    f.puts content_h
  end
end

def create_ansible_cfg
  tmp_ansible_cfg = 'ansible.cfg'

  content = <<'EOF'
remote_user = root
EOF

  File.open(tmp_ansible_cfg, 'w') do |f|
    f.puts content
  end
end

def delete_ansible_cfg
  tmp_ansible_cfg = 'ansible.cfg'
  File.delete(tmp_ansible_cfg)
end

def delete_normality
  tmp_ansiblespec = '.ansiblespec'
  tmp_playbook = 'site.yml'
  tmp_hosts = 'hosts'
  File.delete(tmp_ansiblespec)
  File.delete(tmp_playbook)
  File.delete(tmp_hosts)
end
