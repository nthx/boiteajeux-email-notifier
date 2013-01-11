require './src/configuration'


class NotifyingPlayerOnHisMoveUsecase
  def initialize
    config = Configuration.new
    @url = config.url
    @emails = config.emails
    @game_id = config.game_id
  end

  def start
    check_game_and_notify_current_guy
  end


  def check_game_and_notify_current_guy
    data = retrieve_game_data(@url)
    nick = retrieve_current_player(data)
    if any_nick_was_found(nick) and was_not_yet_notified(nick)
      email = @emails[nick.to_sym]
      if email
        tell_player_its_his_turn(email, nick, @game_id, @url)
      else
        puts "Not sending for: #{nick}"
      end
    end
  end

  def retrieve_game_data(url)
    #aop here
    "example It's Batman turn"
  end


  def retrieve_current_player(data)
    #aop here
    "Batman"
  end

  def was_not_yet_notified(nick)
    true
  end

  def any_nick_was_found(nick)
    if nick
      true
    else
      puts "No nick found in game: #{@game_id}"
      false
    end
  end

  def tell_player_its_his_turn(email, nick, game_id, url)
    #aop here
    puts "Sending to: #{email}"
  end


end
