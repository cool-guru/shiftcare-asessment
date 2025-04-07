require 'json'

class ClientSearcher
  def initialize(file_path)
    @clients = JSON.parse(File.read(file_path))
  end

  def search_by_name(query)
    results = @clients.select { |client| client['full_name'].downcase.include?(query.downcase) }
    puts "Clients matching '#{query}':"
    results.each { |c| puts "#{c['id']}: #{c['full_name']} - #{c['email']}" }
  end

  def find_duplicate_emails
    email_map = Hash.new { |h, k| h[k] = [] }
    @clients.each { |client| email_map[client['email']] << client }

    duplicates = email_map.select { |_, list| list.size > 1 }
    if duplicates.empty?
      puts "No client with same email."
    else
      puts "Clients with the same email:"
      duplicates.each do |email, clients|
        puts "Email: #{email}"
        clients.each { |c| puts "  #{c['id']}: #{c['full_name']}" }
      end
    end
  end
end

if __FILE__ == $0
  if ARGV.empty?
    puts "Usage:"
    puts "ruby main.rb search <name_query>       - Search clients by name"
    puts "ruby main.rb duplicates                - Show duplicate emails"
    exit
  end

  app = ClientSearcher.new("clients.json")

  case ARGV[0]
  when "search"
    app.search_by_name(ARGV[1..].join(" "))
  when "duplicates"
    app.find_duplicate_emails
  else
    puts "Unknown command."
  end
end
