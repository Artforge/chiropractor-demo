# Time::DATE_FORMATS[:full] = "%A, %B %d, %Y"

Time::Date::DATE_FORMATS.merge!(
   :default => '%m/%d/%Y',
   :full => "%A, %B %d, %Y",
   :full_short => "%b %d, %Y",
   :full_no_year => "%A, %B %d",
   :full_no_year_short => "%b %d",
   :full_clipped => "%a, %b %d, %Y",
   :datetime_military => '%Y-%m-%d %H:%M',
   :datetime          => '%Y-%m-%d %I:%M%P',
   :time              => '%I:%M%P',
   :time_military     => '%H:%M%P',
   :datetime_short    => '%m/%d %I:%M',
   :date_short        => '%m.%d.%Y'
)

Time::DATE_FORMATS.merge!(
   :default => '%m/%d/%Y %H:%M:%S',
   :full => "%A, %B %d, %Y",
   :full_short => "%b %d, %Y",
   :full_no_year => "%A, %B %d",
   :full_no_year_short => "%b %d",
   :full_clipped => "%a, %b %d, %Y",
   :datetime_military => '%Y-%m-%d %H:%M',
   :datetime          => '%Y-%m-%d %I:%M%P',
   :time              => '%I:%M%P',
   :time_military     => '%H:%M%P',
   :datetime_short    => '%m/%d %I:%M',
   :date_short        => '%m.%d.%Y'
)

class ActiveSupport::TimeWithZone
    def as_json(options = {})
        strftime('%m/%d/%Y %H:%M:%S')
    end
end

class Date
    def as_json(options = {})
        strftime('%m/%d/%Y')
    end
end