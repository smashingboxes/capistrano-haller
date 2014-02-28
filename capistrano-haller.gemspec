Gem::Specification.new do |spec|
  spec.name        = "capistrano-haller"
  spec.version     = File.open(File.expand_path('../VERSION', __FILE__)).read
  spec.author      = "Jack Forrest"
  spec.email       = "jack@smashingboxes.com"
  spec.homepage    = "https://github.com/smashingboxes/capistrano-haller"
  spec.summary     = %q{Hall chat notifications for capistrano deploys}
  spec.description = %q{Posts messages in hall channels after capistrano deployes}
  spec.license     = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency     "capistrano", "< 3.0"
  spec.add_development_dependency  "rake"
end
