require "rpi_components"

module Starter
  class Ticker
    CYCLE_INTERVAL = 8

    def initialize(lcd_rd: 26, lcd_e: 19, lcd_d4: 13, lcd_d5: 6, lcd_d6: 5, lcd_d7: 11)
      @lcd = RpiComponents::Lcd.new(lcd_rd, lcd_e, lcd_d4, lcd_d5, lcd_d6, lcd_d7)
    end

    def cycle(messages = [])
      in_thread do
        messages.each do |message|
          show message
          sleep CYCLE_INTERVAL
        end
      end

    end

    def clear
      lcd.clear
    end

    private

      attr_accessor :thread
      attr_reader :lcd

      def in_thread
        thread.exit if thread
        self.thread = Thread.new do
          loop do
            yield
          end
        end
      end

      def show(message)
        lcd.message message[:title]
        lcd.message message[:body], 2
      end
  end
end
