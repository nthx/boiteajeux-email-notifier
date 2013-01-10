require './src/usecase'
require './src/services'
require './lib/aquarium_helper'

include AquariumHelper


class Notifier
  def trace_calls(usecase)
    before usecase, :start do |jp|
      puts "Starting..."
    end
    before_all usecase do |jp|
      puts "before: #{jp[0].method_name}"
    end
    after_all usecase do |jp|
      puts "after: #{jp[0].method_name}"
    end
  end

  def apply_glue(usecase, email_service, http_fetcher, page_parser)
  end
end



if __FILE__ == $0
  notifier = Notifier.new

  usecase = Usecase.new

  email_service = EmailService.new
  http_fetcher = HttpFetcher.new
  page_parser = PageParser.new

  notifier.trace_calls(usecase)
  notifier.apply_glue(usecase, email_service, http_fetcher, page_parser)

  usecase.start

end
