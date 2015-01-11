$.fn.extend
  orderable: ->
    @each (i, el) ->
      listName = $(el).data 'orderableParent'
      path = $(el).data 'orderablePath'

      $(el).sortable
        items: "[data-orderable-child=\"#{listName}\"]"
        handle: "[data-orderable-handle=\"#{listName}\"]"
        update: (e, ui) ->
          $.ajax
            url: ui.item.data('orderablePath')
            type: 'PATCH'
            data:
              position: ui.item.index() + 1
            dataType: 'script'

$ ->
  $('[data-orderable-parent]').orderable()
