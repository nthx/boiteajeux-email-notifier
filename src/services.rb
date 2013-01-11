class EmailService
  def send_email(email_to, nick, game_id, url)
    require 'net/smtp'
    require './src/configuration'
    config = Configuration.new
    email_config = config.email

    message = <<EOF
From: Agricola Popychacz <#{email_config[:from]}>
To: #{nick} <#{email_to}>
Subject: Twoj ruch na BojteAjeux #{game_id}

#{nick.capitalize} grasz, a wiesz, ze Twoj ruch? Powodzenia!
#{url}
EOF

    puts "Sending email: #{email_config[:from]} => #{email_to}.."
    smtp = Net::SMTP.new email_config[:smtp], 587
    smtp.enable_starttls
    smtp.start(email_config[:server], email_config[:user], email_config[:pass], :login)
    smtp.send_message message, email_config[:from], email_to
    smtp.finish
  end
end

class HttpFetcher
  require 'open-uri'
  def fetch(url)
    open(url).read
  end
end

class PageParser
  require 'nokogiri'
  def find_nickname_in_a_page(data)
    page = Nokogiri::HTML(data)   
    its_player_turn = page.css("td[class='clInfo']").text
    match = /It's (?<nick>.*)'s turn !/.match(its_player_turn)
    if match
      match[:nick]
    end
  end
end

