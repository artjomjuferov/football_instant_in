class LeavePlusComment
  RECORDS_FILE = 'tmp/added_pluses.json'

  def initialize(browser)
    @browser = browser
  end

  def call
    @browser
      .at_xpath("//form/descendant::node()/div[@role='textbox']")
      .focus
      .type('+', :enter)
    add_record_to_db
  end

  private

  def add_record_to_db
    file = File.open('tmp/added_pluses.json')
    plus_records = JSON.load(file)

    plus_records << ProperThursday.new.call

    File.open(RECORDS_FILE,'w') do |f|
      f.write(plus_records.to_json)
    end
  end
end
