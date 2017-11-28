require "rpi_components"

module Starter
  class Rgb
    COLORS = {
      red: 0x99FFFF,
      green: 0xFF99FF,
      blue: 0xFFFF99
    }

    def initialize(led_r: 17, led_g: 27, led_b: 22)
      @led = RpiComponents::RgbLed.new(led_r, led_g, led_b)
    end

    def set_color(color)
      require 'pry'; binding.pry
      hex = COLORS[color.to_sym]
      if hex
        led.on
        led.set_color hex
      else
        led.off
      end
    end

    def off
      led.off
    end

    private

      attr_reader :led
  end
end
