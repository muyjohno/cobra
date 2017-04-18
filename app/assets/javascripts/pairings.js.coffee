$ ->
  $('.toggle_custom_score').on 'click', (e) ->
    $(@).parents('.round_pairing').find('.preset_score, .custom_score').toggle()
    e.preventDefault()
