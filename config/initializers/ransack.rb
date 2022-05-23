Ransack.configure do |config|
  config.add_predicate :during_month,
                      arel_predicate: 'between',
                      formatter: proc { |v|
                        v.in_time_zone.all_month
                      },
                      type: :date
end