require_relative 'post_analyzer'

class VisitPostIfExists
  GROUP_URL = 'https://www.facebook.com/groups/1722501571383616'

  def initialize(browser)
    @browser = browser
  end

  def call
    visit_group unless in_group?

    (1..3).each do |index|
      sleep 2
      post = load_post(index)
      return true if PostAnalizer.new(@browser, post).suitable?

      visit_group unless in_group? # otherwise it does not find post, after last we don't need to go back because we are going to add +
    end
    false
  end

  private

  def load_post(index)
    @browser.xpath("//div[@role='feed']/div")[index]
  end

  def in_group?
    @browser.current_url == GROUP_URL
  end

  def visit_group
    @browser.goto(GROUP_URL)
  end
end
