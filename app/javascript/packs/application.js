// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "bootstrap"

import '../javascripts/application.js'
import '../stylesheets/application.scss'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

//= require rails-ujs
//= require modernizr-2.6.2.min
//= require activestorage
//= require turbolinks
// require_tree .