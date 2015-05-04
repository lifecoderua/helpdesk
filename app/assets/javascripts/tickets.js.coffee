$(document).ready ->
  # Quick Load
  $quickLoadInput = $('.ticket-quick-load')
  $quickLoadInput.autocomplete {
    source: $quickLoadInput.data('source')
    select: (event, ui) ->
      console.log ui.item
      window.location.href = ui.item.id
  }