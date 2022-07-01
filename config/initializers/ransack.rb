Ransack.configure do |config|
  config.add_predicate :during_month,
                      arel_predicate: 'between',
                      formatter: proc { |v|
                        v.prev_month.beginning_of_month.since(25.days)..v.since(24.days)
                      },
                      type: :date
end