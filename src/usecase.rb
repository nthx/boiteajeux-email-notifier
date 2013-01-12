require './src/configuration'

class PlayerActor
  attr_accessor :nick, :email

  def to_s
    "#{nick} <#{email}>"
  end
end

class BoiteajeuxActor
  attr_reader :game_id, :url, :history_url
  def initialize(game_id)
    @game_id = game_id
    @url = "http://www.boiteajeux.net/jeux/agr/partie.php?id=#{@game_id}"
    @history_url = "http://www.boiteajeux.net/jeux/agr/historique.php?id=#{@game_id}"
  end
end


class NotifyingPlayerOnHisMoveUsecase
  attr_accessor :last_notified_move
  def initialize
    @config = Configuration.new
    @moves_history = {}
    @last_notified_move = nil
  end

  def start
    player = PlayerActor.new
    boiteajeux = BoiteajeuxActor.new(@config.game_id)
    check_game_and_notify_current_guy(player, boiteajeux)
  end

  def check_game_and_notify_current_guy(player, boiteajeux)
    game_data = retrieve_game_data(boiteajeux.url)
    history_of_moves_data = retrieve_history_data(boiteajeux.history_url)

    player.nick = retrieve_current_player(game_data)
    player.email = find_email_in_configuration(player.nick, @config.emails)

    puts "Found player: #{player}"

    if any_nick_was_found(player.nick) 
      @moves_history = retrieve_moves_history(history_of_moves_data)
      if player_not_yet_notified_on_current_game_state
        notify_player(player, boiteajeux)
      else
        puts "Player already notified on move #{current_move}"
      end
    end
  end

  def notify_player(player, boiteajeux)
    if !!player.email
      tell_player_its_his_turn(player.email, player.nick, boiteajeux.game_id, boiteajeux.url)
    else
      puts "Unknown: #{player}"
    end
  end

  def find_email_in_configuration(nick, emails)
    email = emails[nick.to_sym]
  end

  def player_not_yet_notified_on_current_game_state
    if not !!@last_notified_move
      return true
    end
    current_move.to_s != @last_notified_move.to_s
  end

  def current_move
    @moves_history.length
  end

  def retrieve_game_data(url)
    #aop here
    "<html>example It's Batman turn</html>"
  end

  def retrieve_history_data(url)
    #aop here
    "<html>01. Taken grain, ...</html>"
  end


  def retrieve_current_player(game_data)
    #aop here
    "Batman"
  end

  def retrieve_moves_history(history_data)
    #aop here
    {1 => "Taken grain", 2 => "Ploughs field"}
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
