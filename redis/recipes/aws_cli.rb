apt_package "python-pip" do
    action :install
end

execute "install awscli" do
    command "pip install awscli"
    action :run
end

gem_package 'aws-sdk' do 
    action :install
end