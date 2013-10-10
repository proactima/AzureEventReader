require 'spec_helper.rb'
require './tools.rb'

describe Tools do
  context "#convertToMinutes" do
    it "converts 0001 to 1" do
      tools = Tools.new
      converted = tools.convertToMinutes("0001")
      converted.should eq(1)
    end

    it "converts 0010 to 10" do
      tools = Tools.new
      converted = tools.convertToMinutes("0010")
      converted.should eq(10)
    end

    it "converts 0100 to 60" do
      tools = Tools.new
      converted = tools.convertToMinutes("0100")
      converted.should eq(60)
    end

    it "converts 1000 to 600" do
      tools = Tools.new
      converted = tools.convertToMinutes("1000")
      converted.should eq(600)
    end

    it "converts 0524 to 324" do
      tools = Tools.new
      converted = tools.convertToMinutes("0524")
      converted.should eq(324)
    end
  end

  context "#convertToTime" do
    it "converts 1 to 0001" do
      tools = Tools.new
      converted = tools.convertToTime(1)
      converted.should eq("0001")
    end

    it "converts 10 to 0010" do
      tools = Tools.new
      converted = tools.convertToTime(10)
      converted.should eq("0010")
    end

    it "converts 60 to 0100" do
      tools = Tools.new
      converted = tools.convertToTime(60)
      converted.should eq("0100")
    end

    it "converts 600 to 1000" do
      tools = Tools.new
      converted = tools.convertToTime(600)
      converted.should eq("1000")
    end

    it "converts 324 to 0524" do
      tools = Tools.new
      converted = tools.convertToTime(324)
      converted.should eq("0524")
    end
  end
end
