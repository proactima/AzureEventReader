require 'spec_helper.rb'
require './config.rb'

describe AzureConfig do
  let(:configFile) { "configTest.yaml" }

  context "setKey" do
    it "sets the key" do
      config = AzureConfig.new(configFile)
      config.setKey('events.lastPK', 10)

      readConfig = config.getKey('events.lastPK')

      readConfig.should eq(10)
    end

    it "sets the key and reads it back" do
      config = AzureConfig.new(configFile)
      config.setKey('events.lastPK', 10)

      configNew = AzureConfig.new(configFile)
      readConfig = configNew.getKey('events.lastPK')

      readConfig.should eq(10)
    end
  end

  after(:all) do
    if File.exists?(configFile)
      File.delete(configFile)
    end
  end
end
