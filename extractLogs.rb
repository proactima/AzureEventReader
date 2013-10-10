#!/usr/bin/env ruby

require "azure"
require "./config.rb"

config = AzureConfig.new("config.yaml")

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

lastReadPK = convertToMinutes(partitionKey)
lastPkToRead = convertToMinutes(currentTime) - cutOffTime

# Loop from last read PK + 1 to limitPK
#   Query Azure table for events
#   push events to logstash
#

def convertToMinutes(partitionKey)
  return (partitionKey[0..1].to_i * 60) + partitionKey[2..3].to_i
end

def convertToTime(pk)
  minutes = pk % 60
  hours = (pk - minutes) / 60
  time = hours.to_s.rjust(2, '0') + minutes.to_s.rjust(2, '0')
end
