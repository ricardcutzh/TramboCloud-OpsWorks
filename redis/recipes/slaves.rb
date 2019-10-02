log 'nombre de host' do
    message node['hostname']
    level :info
end

log 'ip de host' do
    message node['ipaddress']
    level :info
end