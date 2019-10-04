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
    result = dynamodb.get_item({key:{"master"=>"master_node"}, table_name: "Chef_Ruby"})
    # SI NO EXISTE UN REGISTRO ENTONCES LO INSERTA
    if result.item == nil
        begin
            dynamodb.put_item({item: {"master" => "master_node", "ip"=>node['ipaddress'], "host"=>node['hostname']}, table_name: "Chef_Ruby"})
            node.default[:redis][:slave] = "no"
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
        if result.item['ip'] != node['ipaddress']
            node.default[:redis][:slave] = "yes"
            node.default[:redis][:server][:addr] = result.item['ip']
            log 'conf slave' do
                message "configurar este nodo como esclavo"
                level :info
            end
        else
            node.default[:redis][:slave] = "no"
            log 'conf no slave' do
                message "Este es nodo maestro"
                level :info
            end
        end
    end
end