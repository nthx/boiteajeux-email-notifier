require './src/usecase'
require './src/services'
require './lib/aop.rb'

include AOP

class Notifier
  def test(usecase)
    after usecase, :start do
      puts "usecase ended"
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

  notifier.apply_glue(usecase, email_service, http_fetcher, page_parser)
  notifier.test(usecase)

  usecase.start

end
