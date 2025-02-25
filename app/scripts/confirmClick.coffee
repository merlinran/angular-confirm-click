'use strict'

angular.module 'confirmClick', []

angular.module('confirmClick')
  .directive 'confirmClick', ($timeout) ->
    scope: {}
    link: (scope, element, attrs) ->
      # Original text
      actionText = element.text()

      # Original Width
      textWidth = null

      # Timeout 
      promise = null

      # Already confirmed?
      hasConfirmed = false

      # Default to a false position
      scope.confirmingAction = false

      # Animate
      element.css
        transition: 'all 1s'

      # Toggle text based on current state
      scope.$watch 'confirmingAction', (newVal, oldVal) ->
        # First time?
        if newVal == oldVal == false
          # Set the original width of the text
          textWidth = element[0].offsetWidth

        if scope.confirmingAction
          # Show confirm message
          element.text attrs.confirmMessage
          element.css  maxWidth: '300px'
        else
          # Show original message
          element.text actionText
          element.css  maxWidth: textWidth

      # handle click on button
      element.bind 'click', ->
        # First Click
        if !scope.confirmingAction
          # Show confirm action
          scope.$apply ->
            scope.confirmingAction = true

          # Revert if the user does not confirm
          promise = $timeout ->
            scope.confirmingAction = false
          , 1500

        # Subsequent clicks
        else
          # Stop a double click
          return if hasConfirmed

          # User has confirmed
          hasConfirmed = true
          
          # Ensure the confirm action text remains
          $timeout.cancel promise

          # Indicate click occured
          element.css opacity: '0.5'

          # Trigger action
          scope.$parent.$apply attrs.confirmClick