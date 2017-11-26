$(document).on 'turbolinks:load', ->
  $.get '/identities?side=corp', (data) ->
    $('.corp_identities').each (i, input) ->
      new Awesomplete(input, { list: data })

  $.get '/identities?side=runner', (data) ->
    $('.runner_identities').each (i, input) ->
      new Awesomplete(input, { list: data })
