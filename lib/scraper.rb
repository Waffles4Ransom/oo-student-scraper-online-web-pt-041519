require 'open-uri'
require 'pry'

#'./fixtures/student-site/index.html'
class Scraper

  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(open(index_url))
    students = html.css("div.student-card")
    students.map do |s|
      { 
        name: s.css("div.card-text-container h4").text,
        location: s.css("div.card-text-container p").text,
        profile_url: s.css("a").attr("href").value
      }
    end 
  end


  def self.scrape_profile_page(profile_url)
    profile_data = {}
    html = Nokogiri::HTML(open(profile_url))
    
    html.css("div.social-icon-container a").each do |s|
      if s.attr("href").value.include?("twitter")
        profile_data[:twitter] = s.attr("href").value
      elsif s.attr("href").value.include?("linkedin")
        profile_data[:linkedin] = s.attr("href").value
      elsif s.attr("href").value.include?("github")
        profile_data[:github] = s.attr("href").value
      else
        profile_data[:blog] = s.attr("href").value
      end
    end 
    
    profile_data[:profile_quote] = html.css("div.profile-quote").text
    profile_data[:bio] = html.css("div.description-holder p").text.strip
   
    profile_data
  end

end

