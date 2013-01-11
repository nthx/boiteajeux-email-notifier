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

    apply_glue(usecase, email_service, http_fetcher, page_parser)

    usecase.start
  end

  def apply_glue(usecase, email_service, http_fetcher, page_parser)
    around usecase, :retrieve_game_data do |jp, usecase, url|
      http_fetcher.fetch(url)
    end
    around usecase, :retrieve_current_player do |jp, usecase, data|
      page_parser.find_nickname_in_a_page(data)
    end
    after usecase, :tell_player_its_his_turn do |jp, usecase, email, nick, game_id, url|
      email_service.send_email(email, nick, game_id, url)
    end
  end
end



if __FILE__ == $0
  notifier = Notifier.new
  notifier.run

end
