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

    if !!email_config[:enabled]
      smtp = Net::SMTP.new email_config[:smtp], 587
      smtp.enable_starttls
      smtp.start(email_config[:server], email_config[:user], email_config[:pass], :login)
      smtp.send_message message, email_config[:from], email_to
      smtp.finish
    else
      puts "Email not sent - service disabled"
    end
  end
end

class HttpFetcher
  require 'open-uri'
  def fetch(url)
    puts "Fetching #{url}"
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

  def find_game_over_in_a_page(data)
    page = Nokogiri::HTML(data)
    match = /GAME OVER/.match(page.text)
    if match
      true
    else
      false
    end
  end

  def find_history_in_a_page(data)
    page = Nokogiri::HTML(data)

    nicks = find_nicks(page)
    puts "Nicks found: #{nicks}"

    moves = find_moves(page, nicks)
    puts "Moves: #{moves.length}"

    moves
  end

  def find_moves(page, nicks)
    moves = {}
    history = page.css("td[class='clHisto']")
    history.each do |node|
      if node.children.length <= 1 #node with round number
        nil
      else
        move_number = node.children[0].text
        rest = node.children[1..node.children.length]
        move_text = ''
        rest.each do |child|
          if child.name == 'img'
            move_text << "<img>"
          else
            move_text << "#{child.text}"
          end
        end
        moves[move_number.to_i] = move_text
      end
    end
    moves
  end

  def find_nicks(page)
    header = page.css("th[class='clHisto clHistoFonce']")
    label = "Round #"
    nick_nodes = header.children
    if nick_nodes.length <= 1 or nick_nodes[0].text != label
      raise "Something bad. Only 1 player? No label? #{nick_nodes[0].text}"
    end

    nicks = []
    nick_nodes.each do |node|
      index = 0
      if node.name == 'text' and node.text != label
        nicks << node.text.strip
      end
    end
    nicks
  end
end


class Persistence
  require 'yaml'
  def load_usecase_data(usecase)
    data = begin
      YAML.load(File.open("database.yml"))
    rescue Exception => e
      #puts "Could not parse YAML: #{e.message}"
    end
    puts "Loaded database: #{data}"
    if !!data
      usecase.last_notified_move = data[:last_notified_move]
    end
  end

  def store_usecase_data(usecase)
    data = {:last_notified_move => usecase.current_move}
    File.open("database.yml", "w") {|f| f.write(data.to_yaml) }
  end
end
