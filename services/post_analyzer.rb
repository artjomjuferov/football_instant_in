class PostAnalizer
  def initialize(browser, post)
    @post = post
    @browser = browser
  end

  def suitable?
    suitable_date? && !plus_exists?
  end

  private

  def suitable_date?
    @post.text.include?("Футбол в четверг #{ProperThursday.new.call}")
  end

  def plus_exists?
    a = @post.at_xpath("./descendant::node()/a[contains(@href, 'www.facebook.com/groups/1722501571383616/?post_id=')]")
    @browser.goto(link_for_post(a))
    sleep 2

    @browser
      .at_xpath("//div[@class='tvmbv18p cwj9ozl2']")
      .text
      .include?('Артём Юферов')
  end

  # Leave it for a moment
  def date_span_xpath
    %w[tojvnm2t a6sixzi8 abs2jz4q a8s20v7p t1p8iaqh k5wvi7nf q3lfd5jv pk4s997a bipmatt0 cebpdrjk qowsmv63 owwhemhu dp1hu0rb dhp61c6y iyyx5f41]
      .map{ |x| "@class='#{x}'" }
      .join('and ')
  end


  def link_for_post(a)
    post_id = a.attribute('href').match(/.+post_id=(\d+)/)[1]
    "https://www.facebook.com/groups/1722501571383616/permalink/#{post_id}/"
  end
end
