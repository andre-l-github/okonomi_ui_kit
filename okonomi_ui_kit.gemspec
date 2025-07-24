require_relative "lib/okonomi_ui_kit/version"

Gem::Specification.new do |spec|
  spec.name        = "okonomi_ui_kit"
  spec.version     = OkonomiUiKit::VERSION
  spec.authors     = [ "Okonomi GmbH" ]
  spec.email       = [ "andre.lahs@okonomi.gmbh" ]
  spec.homepage    = "https://okonomi.gmbh"
  spec.summary     = "UI Kit for Okonomi applications"
  spec.description = "UI Kit for Okonomi applications"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://okonomi.gmbh"
  spec.metadata["changelog_uri"] = "https://okonomi.gmbh"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.0"
  spec.add_dependency "tailwindcss-ruby"
  spec.add_dependency "tailwindcss-rails"
end
