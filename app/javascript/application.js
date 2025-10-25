// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chart.js"

document.addEventListener('turbo:load', function() {
    if (window.location.hash) {
        window.location.hash = window.location.hash;
    }
});
