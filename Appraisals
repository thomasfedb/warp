["3.2", "4.0", "4.1", "4.2"].each do |rails|
  ["3.0", "3.1", "3.2", "3.3"].each do |rspec|
    appraise "rails-#{rails}-rspec-#{rspec}" do
      rails_v = "~> #{rails}"

      gem "activesupport", rails_v, require: "active_support/all"
      gem "actionpack", rails_v, require: "action_controller"
      gem "activerecord", rails_v, require: "active_record"
      gem "actionview", rails_v, require: "action_view" if rails == "4.1"

      gem "rspec", "~> #{rspec}"
    end
  end
end
