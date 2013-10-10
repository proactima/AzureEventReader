#!/usr/bin/env ruby

require "azure"
require "./config.rb"
require "./tools.rb"

config = AzureConfig.new("config.yaml")
tools = Tools.new

partitionKey = config.getKey('events.lastPK')
tableDate = config.getKey('events.lastReadTable')
tablePrefix = config.getKey('events.tablePrefix')
cutOffTime = config.getKey('events.cutOffFromNow')

rollOverTime = 1439 # 23:59

localTime = Time.now
utcTime = localTime.getutc
currentDate = localTime.strftime('%Y%m%d')
currentTime = utcTime.strftime('%H%M')

partitionKey ||= currentTime
tableDate ||= currentDate
tablePrefix ||= "Logs"
table = tablePrefix + tableDate

config.setKey('events.lastReadTable', currentDate)
config.setKey('events.tablePrefix', tablePrefix)

Azure.configure do |aConfig|
  aConfig.storage_account_name = config.getKey('azure.storage_account_name')
  aConfig.storage_access_key = config.getKey('azure.storage_access_key')
end

lastReadPK = tools.convertToMinutes(partitionKey.to_s)
lastPkToRead = tools.convertToMinutes(currentTime.to_s) - cutOffTime

#puts "lastReadPK: #{partitionKey} # #{lastReadPK}"
#puts "lastPkToRead: #{currentTime} - #{cutOffTime} # #{lastPkToRead}"

# Loop from last read PK + 1 to limitPK
#   Query Azure table for events
#   push events to logstash
#

azureTableService = Azure::TableService.new

readPk = lastReadPK + 1

if (lastPkToRead < lastReadPK)
  # We need to roll over to next date
  (lastReadPK+1..rollOverTime).each do |pk|
    query = { :filter => "PartitionKey eq #{pk.to_s}" }
    puts query
    readPk = pk.to_s
  end

  (0..lastPkToRead).each do |pk|
    query = { :filter => "PartitionKey eq #{pk.to_s}" }
    puts query
    readPk = pk.to_s
  end
else
  puts "No rollover"
  (lastReadPK+1..lastPkToRead).each do |pk|
    query = { :filter => "PartitionKey eq '#{tools.convertToTime(pk)}'" }
    puts query
    puts "Table: #{table}"
    result = azureTableService.query_entities(table, query)
    result.each do |r|
      puts "Event found #{r.properties}"
    end
    readPk = pk.to_s
  end
end

#config.setKey('events.lastPK', tools.convertToTime(readPk.to_i))
