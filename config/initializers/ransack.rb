Ransack.configure do |config|
  config.add_predicate :cash_month,
                      arel_predicate: 'between',
                      formatter: proc { |v|
                        v.in_time_zone.prev_month.beginning_of_month.since(24.days)..v.in_time_zone.beginning_of_month.since(25.days)
                      },
                      type: :date
end