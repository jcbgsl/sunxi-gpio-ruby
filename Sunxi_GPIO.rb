module Sunxi_GPIO

  OUT = "out"
  IN = "in"
  HIGH = "1"
  LOW = "0"
  EXPORT_FILE = "/sys/class/gpio/export"
  UNEXPORT_FILE = "/sys/class/gpio/unexport"
  DIRECTION = "/direction"
  VALUE = "/value"
  
  class Pin
    @name
    @pinnumber
    @direction
    @directory
    def initialize(name,pinnumber,direction)
      @name = name
      @pinnumber = pinnumber.to_s
      @direction = direction
      @directory = "/sys/class/gpio/gpio" + @pinnumber + "_" + @name.downcase
    end
    def setup
      if !File.directory?(@directory)
        `echo #{@pinnumber} > #{EXPORT_FILE}` 
        sleep(0.1) until File.writable?(@directory + DIRECTION)
      end
      `echo #{@direction} > #{@directory}#{DIRECTION}`
    end
    def teardown
      if File.directory?(@directory)
        `echo #{@pinnumber} > #{UNEXPORT_FILE}` 
      end
    end
  end

  class Pin_Out < Pin
    def initialize(name,pinnumber)
      super(name,pinnumber,OUT)
    end

    def high
      `echo #{HIGH} > #{@directory}#{VALUE}`
    end

    def low
      `echo #{LOW} > #{@directory}#{VALUE}`
    end
  end

  class Pin_In < Pin
    def initialize(name,pinnumber)
      super(name,pinnumber,IN)
    end
    def value?
      `cat #{@directory}/value`
    end
  end

end
