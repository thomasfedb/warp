class V
  def initialize(*version_parts)
    @version_parts = version_parts
  end

  def self.[](version_string)
    self.new(*version_string.split("."))
  end

  def gem_version
    case @version_parts.size
    when 2
      "~> " + human_version
    when 3, 4
      human_version
    else
      raise Exception, "cannot generate gem version for #{human_version}"
    end
  end

  def human_version
    @version_parts.join(".")
  end

  def git?
    @version_parts.size == 1
  end

  def branch
    @version_parts[0]
  end

  def major
    @version_parts[0]
  end

  def minor
    git? ? nil : @version_parts[1]
  end

  def mm
    [major, minor].join(".")
  end

  def mm?(version)
    mm == version
  end
end

[V["3.2"], V["4.0"], V["4.1.0.beta1"]].each do |rails|
  [V["2.14"], V["2.99.0.beta1"], V["3.0.0.beta1"], V["master"]].each do |rspec|
    appraise "rails-#{rails.human_version}-rspec-#{rspec.human_version}" do
      gem "activesupport", rails.gem_version, require: "active_support/all"
      gem "actionpack", rails.gem_version, require: "action_controller"
      gem "activerecord", rails.gem_version, require: "active_record"
      gem "actionview", rails.gem_version, require: "action_view" if rails.mm?("4.1")

      ["rspec", "rspec-core", "rspec-expectations", "rspec-mocks", "rspec-support"].each do |rspec_gem|
        if rspec.git?
          gem rspec_gem, git: "https://github.com/rspec/#{rspec_gem}.git", branch: rspec.branch
        elsif rspec_gem != "rspec-support" || rspec.mm?("3.0")
          gem rspec_gem, rspec.gem_version
        end
      end
    end
  end
end