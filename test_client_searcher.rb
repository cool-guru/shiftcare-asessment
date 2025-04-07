require 'minitest/autorun'
require_relative 'main'
require 'json'
require 'tempfile'

class TestClientSearcher < Minitest::Test
  def setup
    @tempfile = Tempfile.new('clients.json')
    data = [
      { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
      { "id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@example.com" },
      { "id" => 3, "full_name" => "Another Jane", "email" => "jane.smith@example.com" },
      { "id" => 4, "full_name" => "Alex Johnson", "email" => "alex.johnson@example.com" }
    ]
    @tempfile.write(data.to_json)
    @tempfile.rewind

    @client_searcher = ClientSearcher.new(@tempfile.path)
  end

  def teardown
    @tempfile.close
    @tempfile.unlink
  end

  def test_search_by_name
    output = capture_io do
      @client_searcher.search_by_name("Jane")
    end.first

    assert_includes output, "2: Jane Smith"
    assert_includes output, "3: Another Jane"
    refute_includes output, "John Doe"
  end

  def test_find_duplicate_emails
    output = capture_io do
      @client_searcher.find_duplicate_emails
    end.first

    assert_includes output, "Clients with the same email:"
    assert_includes output, "Email: jane.smith@example.com"
    assert_includes output, "2: Jane Smith"
    assert_includes output, "3: Another Jane"
  end

  def test_find_no_duplicate_emails
    data = [
      { "id" => 1, "full_name" => "Solo User", "email" => "solo@example.com" }
    ]
    @tempfile.rewind
    @tempfile.truncate(0)  # Clear old content
    @tempfile.write(data.to_json)
    @tempfile.flush
  
    new_searcher = ClientSearcher.new(@tempfile.path)
    output = capture_io do
      new_searcher.find_duplicate_emails
    end.first
  
    assert_includes output, "No client with same email."
  end
end
