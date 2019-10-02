log 'nombre de host' do
    message node['hostname']
    level :info
end