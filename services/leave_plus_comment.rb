class LeavePlusComment
  def initialize(browser)
    @browser = browser
  end

  def call
    @browser
      .at_xpath("//div[@aria-label='Comment on post']")
      .focus
      .type('+', :enter)
    p "I'm playing football on Thursday"
  end
end
