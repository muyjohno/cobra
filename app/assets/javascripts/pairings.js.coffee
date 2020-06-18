$(document).on 'turbolinks:load', ->
  $('.toggle_custom_score').on 'click', (e) ->
    $(@).parents('.round_pairing').find('.preset_score, .custom_score').toggle()
    e.preventDefault()

  if localStorage['hide_reported'] && JSON.parse(localStorage['hide_reported'])
    $('.reported').hide()
  else
    localStorage['hide_reported'] = false
    $('.reported_hidden_message').hide()

  $('#toggle_reported').on 'click', (e) ->
    $('.reported').toggle()
    $('.reported_hidden_message').toggle()
    localStorage['hide_reported'] = !JSON.parse(localStorage['hide_reported'])

  if localStorage['show_identities'] && JSON.parse(localStorage['show_identities'])
    $('.round_pairing .ids').show()
  else
    localStorage['show_identities'] = false
    $('.round_pairing .ids').hide()

  $('#toggle_identities').on 'click', (e) ->
    $('.round_pairing .ids').toggle()
    localStorage['show_identities'] = !JSON.parse(localStorage['show_identities'])
