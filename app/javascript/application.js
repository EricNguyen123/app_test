// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"
// import "./controllers/hello_controller.js"

import "jquery"
import "jquery_ujs"
import "popper"
import "bootstrap"
import {} from 'jquery-ujs'


import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false