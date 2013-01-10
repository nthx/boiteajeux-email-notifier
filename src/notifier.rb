require './src/usecase'
require './src/services'
require './lib/aop.rb'

class Notifier
  def trace_calls(usecase)
    before_all usecase do
      puts "before_all"
    end

    before usecase, :start do
      puts "starting usecase.."
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
