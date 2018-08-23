$(document).on 'turbolinks:load', ->
  $('.toggle_custom_score').on 'click', (e) ->
    $(@).parents('.round_pairing').find('.preset_score, .custom_score').toggle()
    e.preventDefault()

  if JSON.parse(localStorage['hide_reported'])
    $('.reported').hide()
  else
    $('.reported_hidden_message').hide()
  $('#toggle_reported').on 'click', (e) ->
    $('.reported').toggle()
    $('.reported_hidden_message').toggle()
    localStorage['hide_reported'] = !JSON.parse(localStorage['hide_reported'])
