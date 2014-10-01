require './src/usecase'
require './src/services'
require './lib/aquarium_helper'

include AquariumHelper


class Notifier

  def run
    usecase = NotifyingPlayerOnHisMoveUsecase.new

    email_service = EmailService.new
    http_fetcher = HttpFetcher.new
    page_parser = PageParser.new
    persistence = Persistence.new

    apply_glue(usecase, email_service, http_fetcher, page_parser, persistence)

    usecase.start
  end

  def apply_glue(usecase, email_service, http_fetcher, page_parser, persistence)
    around usecase, :retrieve_game_data do |jp, usecase, url|
      http_fetcher.fetch(url)
    end
    around usecase, :retrieve_history_data do |jp, usecase, url|
      http_fetcher.fetch(url)
    end

    around usecase, :get_game_current_nick do |jp, usecase, data|
      page_parser.find_nickname_in_a_page(data)
    end
    around usecase, :get_moves_history do |jp, usecase, data|
      page_parser.find_history_in_a_page(data)
    end
    around usecase, :check_if_its_game_over do |jp, usecase, data|
      page_parser.find_game_over_in_a_page(data)
    end

    after usecase, :tell_player_its_his_turn do |jp, usecase, email, nick, game_id, url, moves_history, last_notified_move|
      email_service.send_email(email, nick, game_id, url, moves_history, last_notified_move)
    end

    before usecase, :start do |jp, usecase|
      persistence.load_usecase_data(usecase)
    end
    after usecase, :notify_player do |jp, usecase, player, boiteajeux, moves_history|
      persistence.store_usecase_data(usecase)
    end
  end
end



if __FILE__ == $0
  notifier = Notifier.new
  notifier.run

end
