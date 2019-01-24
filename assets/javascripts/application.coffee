# Use the Yaffle EventSource polyfill to work around browser issues
#= require eventsource.min.js

# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js

#= require_directory .
#= require_tree ../../widgets

console.log("Yeah! The dashboard has started!")

Dashing.on 'ready', ->
  Dashing.widget_margins ||= [5, 5]
  Dashing.widget_base_dimensions ||= [145, 145]
  Dashing.numColumns ||= 7
  Dashing.cycleDashboards({timeInSeconds: 0, stagger: true, page: 1});

  contentWidth = (Dashing.widget_base_dimensions[0] + Dashing.widget_margins[0] * 2) * Dashing.numColumns

  Batman.setImmediate ->
    $('.gridster').width(contentWidth)
    $('.gridster ul:first').gridster
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      avoid_overlapped_widgets: !Dashing.customGridsterLayout
      draggable:
        stop: Dashing.showGridsterInstructions
        start: -> Dashing.currentWidgetPositions = Dashing.getWidgetPositions()
		 
  Batman.Filters.fixed = (num, f) ->
    return parseFloat(num).toFixed(f)

  Batman.Filters.shortenedWattage = (num) ->
    return num if isNaN(num)
    if num >= 1000
      (num / 1000).toFixed(1) + 'kW'
    else
      num + 'W'