require "psych"

class AzureConfig
  @config = nil
  @file = nil

  def initialize(fileName)
    @file = fileName
    if !File.exists?(@file)
      @config = {
        "events" => {
          "lastPK" => nil,
          "lastDeletedTable" => nil,
          "lastReadTable" => nil,
          "tablePrefix" => nil,
          "cutOffFromNow" => 2
        },
        "azure" => {
          "storage_account_name" => nil,
          "storage_access_key" => nil
        }
      }
      saveConfig
    end
    @config = Psych.load_file(@file)
  end

  def saveConfig
    File.write(@file, @config.to_yaml)
  end

  # getKey and setKey based on this article:
  # http://stackoverflow.com/questions/14294751/how-to-set-nested-hash-in-ruby-dynamically
  def getKey(key)
    return key.split('.').inject(@config, :[])
  end

  def setKey(key, value)
    *key, last = key.split('.')
    key.inject(@config, :fetch)[last] = value 
    saveConfig
  end

end
