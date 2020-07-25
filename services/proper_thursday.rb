class ProperThursday
  def call
    date = Date.today
    (date + (1 + ((3-date.wday) % 7))).strftime('%d.%m')
  end
end
