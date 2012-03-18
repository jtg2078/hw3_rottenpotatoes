# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    # | title                   | rating | release_date |
    Movie.find_or_create_by_title(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date])
    # Movie.new(:title => movie.title, :rating => movie.rating, :release_date => movie.release_date)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #assert false, "Unimplmemented"
  pattern = Regexp.new("#{e1}.*#{e2}", Regexp::MULTILINE)
  match = page.body.match(pattern)
  # Sputs page.body
  assert match.nil? == false
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
  	if uncheck.nil?
  		step %Q{I check "#{("ratings_"+ rating.strip)}"}
  	else
  		step %Q{I uncheck "#{("ratings_"+ rating.strip)}"}
  	end
  end
end

# Make it easier to express checking if all movies listed
#	"Then I should see all of the movies"

Then /I should see all of the movies/ do
	rows = Movie.count
	# puts page.body
	# puts rows
	assert page.has_selector?('tbody tr', :count => rows)
end

# Make it easier to express checking if no movies listed
#	"Then I should see none of the movies"

Then /I should see none of the movies/ do
	rows = Movie.count
	assert rows == 0
end
