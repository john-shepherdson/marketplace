# frozen_string_literal: true

task default: ["test:system", "test", "test:js"]

namespace :test do
  task js: :environment do
    sh "yarn test"
  end
end
