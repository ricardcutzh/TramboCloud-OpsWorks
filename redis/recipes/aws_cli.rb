log 'nombre de host' do
    message node['hostname']
    level :info
end

log 'ip de host' do
    message node['ipaddress']
    level :info
end

log 'Rol asociado' do
    message node['roles']
    level :info
end

apt_package "python-pip" do
    action :install
end

execute "install awscli" do
    command "pip install awscli"
    action :run
end