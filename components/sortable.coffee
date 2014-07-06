# Inspired by https://gist.github.com/petehunt/7882164
#
# depends on
#     jQuery UI Sortable

(exports) ->

  exports.Sortable = React.createClass

    getDefaultProps: -> {}

    render: ->
      @transferPropsTo(React.DOM.div())

    componentDidMount: ->
      $domNode = $(@getDOMNode())
      $domNode.sortable({stop: @handleDrop, axis: "y"})
      for child, i in @getChildren()
        $child = $('<div class="sortable-item"></div>')
        $domNode.append($child)
        $child.data('reactSortablePos', i)
        React.renderComponent(React.addons.cloneWithProps(child), $child[0])

    componentWillUnmount: ->
      for node in $(@getDOMNode()).children()
        React.unmountComponentAtNode(node)

    componentDidUpdate: ->
      $domNode = $(@getDOMNode())
      childIndex = 0
      nodeIndex = 0
      children = @getChildren()
      nodes = $domNode.children().get()
      numChildren = children.length
      numNodes = nodes.length

      while childIndex < numChildren
        if nodeIndex >= numNodes
          $child = $('<div class="sortable-item"></div>')
          $domNode.append($child)
          $child.data('reactSortablePos', numNodes)
          nodes.push($child[0])
          numNodes++
        React.renderComponent(
          React.addons.cloneWithProps(children[childIndex]),
          nodes[nodeIndex]
        )
        childIndex++
        nodeIndex++

      while nodeIndex < numNodes
        React.unmountComponentAtNode(nodes[nodeIndex])
        $(nodes[nodeIndex]).remove()
        nodeIndex++

    getChildren: ->
      @props.children || []

    handleDrop: ->
      newOrder = (
        for node in $(@getDOMNode()).children()
          $(node).data('reactSortablePos')
      )
      for node, i in $(@getDOMNode()).children()
        $(node).data('reactSortablePos', i)
      @props.onSort(newOrder)
