require "serialport"
require "twitter"

module Cubix
  class Move
    def initialize(sp = "/dev/tty.usbmodem621")
      @serial_port = SerialPort.new(sp)

      @twitter = Twitter::REST::Client.new do |config|
        config.consumer_key        = "VpRPS1sR1FdYhWmMmkScIlpIc"
        config.consumer_secret     = "w1AEtf1BDo3DYZljAKT2E72XjIGVAf2iDOaZnpqxS9OFblefQK"
        config.access_token        = "127201256-NA8Gi2WGFfJQcOiEqlYUllx7bVVqBxpldS0xgkIB"
        config.access_token_secret = "UNLQkjCIWai6K84CHPxoaL729wxEAs8IeefM6QOKCiVXV"
      end
    end

    def clockwise
      @serial_port.write 2
    end

    def counterclockwise
      @serial_port.write 1
    end

    def show_smiley(current_cube_position, new_cube_position)
      moves = current_cube_position - new_cube_position

      moves.abs.times do
        moves < 0 ? self.clockwise : self.counterclockwise
      end
    end

    def search_tweets
      last_tweet_created_at = Time.now - 24 * 60 * 60
      # N 0: :)
      # W 1: :D
      # S 2: :(
      # E 3: ;)
      current_cube_position = 0
      i = 0

      while true
        @twitter.search("#SWBerlin", :result_type => "recent").take(1).each do |tweet|
          if tweet.created_at > last_tweet_created_at
            puts "Text: #{tweet.text} | Created at: #{tweet.created_at}"

            if tweet.text =~ /(\:|\=)\-?\)/
              puts ":)"
              self.show_smiley(current_cube_position, 0)
              current_cube_position = 0
            elsif tweet.text =~ /\:\-?D/
              puts ":D"
              self.show_smiley(current_cube_position, 1)
              current_cube_position = 1
            # elsif tweet.text =~ /\:\-?\(/
            #   puts ":("
            #   self.show_smiley(current_cube_position, 2)
            #   current_cube_position = 2
            elsif tweet.text =~ /\;\-?\)/
              puts ";)"
              self.show_smiley(current_cube_position, 3)
              current_cube_position = 3
            end

            last_tweet_created_at = tweet.created_at
            i = 0
          end
        end

        i += 1

        if i == 6 # Set smiley automatically to :( after 30 seconds:
          puts ":("
          self.show_smiley(current_cube_position, 2)
          current_cube_position = 2
        end

        puts "."
        sleep 5
      end
    end
  end
end

cubix = Cubix::Move.new
cubix.search_tweets