# =require jquery
# =require bootstrap

$('a[href="' + document.location.pathname + '"]').closest('li').addClass('active')

timeout = 1000

update_status = (data) ->
  for entry in data
    do (entry) ->
      if entry.status == 'uptodate'
        $indicator = $('#' + entry.id + ' .outdated')
        $indicator.removeClass('outdated').addClass('uptodate')
  if $('.outdated').size() > 0
    setTimeout(poll_status, timeout)

poll_status = ->
  $.getJSON '/status', update_status

if $('.outdated').size() > 0
  poll_status()
