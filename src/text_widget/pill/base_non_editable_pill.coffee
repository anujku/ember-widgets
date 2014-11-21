# Base class for NonEditablePill that can be inserted into the TextEditorWithNonEditableComponent
Ember.Widgets.BaseNonEditablePill = Ember.Controller.extend Ember.Widgets.DomHelper,

  textEditor: null
  params: Ember.computed -> {}

  ##############################################################################
  # Interface
  ##############################################################################

  name: null

  # Returns a string that is displayed to the user in the non-editable pill in the text editor.
  # This method is called whenever the text editor view is refreshed. Needs to be overriden.
  result: -> Ember.K

  # Configure the parameters of the pill, e.g. by displaying a modal with input options that are
  # then stored in @get('params')
  configure: ->
    @send 'modalConfirm'  # No configuration by default

  update: ->
    $(@_getElement()).text(@result())

  ##############################################################################

  actions:
    modalConfirm: ->
      if @get 'params.pillId'
        @get('textEditor').updatePill this
      else
        @set 'params.pillId', @get('textEditor').getNewPillId()
        @set 'params.type', "" + @constructor
        @get('textEditor').insertPill this
    modalCancel: -> Ember.K

  # Update the text of the pill with the latest results
  updateContent: ->
    $(@get('pillElement')).text(@result())

  # Create a span element containing the correct text and with class=non-editable, that will then
  # be inserted into the text editor DOM.
  render: ->
    span = @createElementsFromString("<span></span>")
    span.addClass('non-editable')
    span.attr('title': @get('name'))
    span.attr('contenteditable': "false")
    # include all params as data-attributes
    for key, value of @get('params')
      span.attr('data-' + Ember.String.dasherize(key), value)
    @set 'pillElement', span
    @updateContent(span)
    return span[0]

  ##############################################################################
  # Private Methods
  ##############################################################################

  _getElement: ->
    pillId = @get('params.pillId')
    @get('textEditor').getEditor().find(".non-editable[data-pill-id='#{pillId}']")

