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

localTime = Time.now
utcTime = localTime.getutc
currentDate = localTime.strftime('%Y-%m-%d')
currentTime = utcTime.strftime('%H%M')

partitionKey ||= currentTime
tableDate ||= currentDate
tablePrefix ||= "Logs_"
table = tablePrefix + tableDate

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

readPk = lastReadPK + 1

(lastReadPK+1..lastPkToRead).each do |pk|
  query = { :filter => "PartitionKey eq #{pk.to_s}" }
  puts query
  readPk = pk.to_s
end

config.setKey('events.lastPK', tools.convertToTime(readPk.to_i))
