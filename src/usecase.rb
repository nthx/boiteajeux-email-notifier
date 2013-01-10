require './src/configuration'


class Usecase
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
    puts "Got nick: #{nick}"
    if was_not_yet_notified(nick)
      email = @emails[nick.to_sym]
      if email
        puts "SENDING TO: #{email}"
        tell_player_its_his_turn(email, nick, @game_id, @url)
      else
        puts "NOT SENDING: #{nick}"
        
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

  def tell_player_its_his_turn(email, nick, game_id, url)
    #aop here
    puts "Its your turn #{email}. Is it? I should send an email though"
  end


end
