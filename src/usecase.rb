require './src/configuration'

class PlayerActor
  attr_accessor :nick, :email

  def to_s
    "#{nick} <#{email}>"
  end
end

class BoiteajeuxActor
  attr_reader :url, :game_id
  def initialize(url, game_id)
    @url = url
    @game_id = game_id
  end
end


class NotifyingPlayerOnHisMoveUsecase
  def initialize
    @config = Configuration.new
  end

  def start
    player = PlayerActor.new
    boiteajeux = BoiteajeuxActor.new(@config.url, @config.game_id)
    check_game_and_notify_current_guy(player, boiteajeux)
  end

  def check_game_and_notify_current_guy(player, boiteajeux)
    data = retrieve_game_data(boiteajeux.url)
    player.nick = retrieve_current_player(data)
    player.email = find_email_in_configuration(player.nick, @config.emails)

    puts "Found player: #{player}"

    if any_nick_was_found(player.nick) and was_not_yet_notified(player)
      if !!player.email
        tell_player_its_his_turn(player.email, player.nick, boiteajeux.game_id, boiteajeux.url)
      else
        puts "Unknown: #{player}"
      end
    end
  end

  def find_email_in_configuration(nick, emails)
    email = emails[nick.to_sym]
  end

  def retrieve_game_data(url)
    #aop here
    "<html>example It's Batman turn</html>"
  end


  def retrieve_current_player(data)
    #aop here
    "Batman"
  end

  def was_not_yet_notified(player)
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
  end


end
