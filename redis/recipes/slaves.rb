master_instance = search("aws_opworks_instance", "self:true").first

search("aws_opsworks_instance", "layer_ids:#{layer_id}").each do |instance|
    puts instance['hostname']
end