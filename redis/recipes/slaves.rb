package 'awscli'
require "aws-sdk-opsworks"

master_instance = search("aws_opworks_instance", "self:true").first
layer_id = master_instance["layer_ids"][0]
search("aws_opsworks_instance", "layer_ids:#{layer_id}").each do |instance|
    puts instance['hostname']
end