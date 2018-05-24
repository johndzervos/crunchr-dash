class Dashing.Shoutbox extends Dashing.Widget

  constructor: ->
    super

  onData: (data) ->
    if @type
      type = @type.toLowerCase()
    else
      type = ""

    if [
      'alarm',
      'alert',
      'angry',
      'birthday',
      'black',
      'christmas',
      'celebrating',
      'funny',
      'happy',
      'love'
      ].indexOf(type) != -1
      currentClass = "shoutbox-#{type}"
    else
      currentClass = "shoutbox-neutral"

    lastClass = @lastClass
    if lastClass != currentClass
      $(@node).toggleClass("#{lastClass} #{currentClass}")
      @lastClass = currentClass

      audiosound = @get(type + 'sound')
      audioplayer = new Audio(audiosound) if audiosound?
      if audioplayer
        audioplayer.play()

  ready: ->
    @onData(null)
