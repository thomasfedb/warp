["3.2", "4.0", "4.1"].each do |rails|
  ["2.99", "3.0", "3.1"].each do |rspec|
    appraise "rails-#{rails}-rspec-#{rspec}" do
      rails_v = "~> #{rails}"
      rspec_v = "~> #{rspec}"

      gem "activesupport", rails_v, require: "active_support/all"
      gem "actionpack", rails_v, require: "action_controller"
      gem "activerecord", rails_v, require: "active_record"
      gem "actionview", rails_v, require: "action_view" if rails == "4.1"

      gem "rspec", rspec_v
      gem "rspec-core", rspec_v
      gem "rspec-expectations", rspec_v
      gem "rspec-mocks", rspec_v
      gem "rspec-support", rspec_v unless rspec == "2.99"
    end
  end
end