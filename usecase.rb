require './configuration'


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
    player = retrieve_current_player(data)
    if was_not_yet_notified(player)
      email = @emails[player]
      tell_player_its_his_turn(email, @game_id, @url)
    end
  end

  def retrieve_game_data(url)
    #aop here
  end


  def retrieve_current_player(data)
    #aop here
  end

  def was_not_yet_notified(player)
    true
  end

  def tell_player_its_his_turn(email, game_id, url)
    #aop here
    puts "Its your turn #{email}. Is it? I should send an email though"
  end


end
