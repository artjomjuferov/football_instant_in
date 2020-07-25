class LeavePlusComment
  RECORDS_FILE = 'tmp/added_pluses.json'

  def initialize(browser)
    @browser = browser
  end

  def call
    @browser
      .at_xpath("//div[@aria-label='Comment on post']")
      .focus
      .type('+', :enter)
  end

  private

  def add_record_to_db
    File.open(RECORDS_FILE,'w') do |f|
      f.write((plus_records << ProperThursday.new.call).to_json)
    end
  end

  def plus_records
    file = File.open('tmp/added_pluses.json')
    JSON.load(file)
  end
end
