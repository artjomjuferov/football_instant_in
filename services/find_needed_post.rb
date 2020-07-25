require_relative 'post_analyzer'

class FindNeededPost
  def initialize(browser)
    @browser = browser
  end

  def call
    visit_group unless in_group?

    (1..3).each do |index|
      sleep 2
      post = load_post(index)
      if PostAnalizer.new(@browser, post).suitable?
        p 'Found post'
        return post
      end
      @browser.back # otherwise it does not find post, after last we don't need to go back because we are going to add +
    end
    p 'Post was not found'
    nil
  end

  private

  def load_post(index)
    @browser.xpath("//div[@role='feed']/div")[index]
  end

  def in_group?
    @browser.current_url == 'https://www.facebook.com/groups/1722501571383616'
  end

  def visit_group
    @browser.goto("https://www.facebook.com/groups/1722501571383616")
  end
end
