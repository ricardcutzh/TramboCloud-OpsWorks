require "aws-sdk-dynamodb"

log 'nombre de host' do
    message node['hostname']
    level :info
end

log 'ip de host' do
    message node['ipaddress']
    level :info
end

# DYNAMO INTERACTION
dynamodb = Aws::DynamoDB::Client.new(region: 'us-west-2')

# CHECKING IF THERE AR ITEMS IN THE TABLE
params = {
    table_name: 'Chef_Ruby',
    key: {
        "master" => "master_node"
    }
}

begin
    result = dynamodb.get_item(params)
    # SI NO EXISTE UN REGISTRO ENTONCES LO INSERTA
    if result.item == nil
        item = {
            key: {
                "master" => 'master_node'
            },   
            "ip" => node['ipaddress'],
            "host"=> node['hostname']
        }
        pars = {
            table_name: 'Chef_Ruby',
            item: item
        }
        begin
            dynamodb.put_item(params)
            log 'master' do
                message 'Configurando master'
                level :info
            end
        rescue StandardError => e
            log 'error' do
                message e.message
                level :info
            end
        end
    # SI YA EXISTE UN REGISTRO ENTONCES SOLO CONFIGURA SLAVES
    else
        log 'slave' do
            message 'Configurando slave'
            level :info
        end
    end
end