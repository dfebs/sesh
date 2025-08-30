# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@4.5.0/dist/chart.js" # @4.5.0
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.4

# chart.js was pinned using `bin/importmap pin chart.js`
# also do `bin/rails assets:precompile` when newly adding the things (might not actually be needed tbh)
# manually needed to include cdn.jsdelivr link on the chart.js line
