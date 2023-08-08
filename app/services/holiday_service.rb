class HolidayService
  def upcoming_holidays
    response = HTTParty.get("https://date.nager.at/api/v3/NextPublicHolidays/US")
    upcoming_3 = Hash.new
    3.times do |value|
      holiday = response[value]
      
      local_name = holiday["localName"]
      date = holiday["date"]
      formatted_date = Date.parse(date).strftime('%B %d, %Y')
      
      upcoming_3[local_name] = formatted_date
    end
    upcoming_3
  end
end