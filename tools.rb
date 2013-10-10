class Tools
  def initialize

  end

  def convertToMinutes(partitionKey)
    minutes = (partitionKey[0..1].to_i * 60) + partitionKey[2..3].to_i
    return minutes.to_i
  end

  def convertToTime(minutes)
    mins = minutes % 60
    hours = (minutes - mins) / 60
    return hours.to_s.rjust(2, '0') + mins.to_s.rjust(2, '0')
  end
end
