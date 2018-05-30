$(document).on 'turbolinks:load', ->
  if $('.identities_form').length
    $.get '/identities', (data) ->
      $('.corp_identities').each (i, input) ->
        new Awesomplete(input, { list: data.corp })

      $('.runner_identities').each (i, input) ->
        new Awesomplete(input, { list: data.runner })
