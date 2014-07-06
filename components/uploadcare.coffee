# depends on
#     uploadcare.js ( https://uploadcare.com/quick_start/ )


(exports) ->

  cleanInfo = (info) ->
    uuid: info.uuid
    name: info.name
    size: info.size
    cdnUrl: info.cdnUrl


  exports.Uploadcare = React.createClass

    componentDidMount: ->
      $el = $(this.getDOMNode())
      $ucInput = $("""
        <input
          type="hidden"
          role="uploadcare-uploader"
          data-clearable="true"
          data-autostore="true"
          #{if @props.multiple then 'data-multiple="true"' else ''}
          #{if @props.uuid then 'value="' + @props.uuid + '"' else ''}
          #{unless @props.anyFile then 'data-images-only="true"' else ''}
        >
      """)
      $el.append($ucInput)

      if @props.multiple
        widget = uploadcare.MultipleWidget($ucInput)
        widget.onChange (group) =>
          if (group)
            $.when($.when.apply($, group.files()), group.promise()).done (fileInfos, groupInfo) =>
              if !('length' of fileInfos) # stupid $.when()
                fileInfos = [fileInfos]
              @props.onChange({
                files: (cleanInfo(f) for f in fileInfos)
                group: cleanInfo(groupInfo)
              })
          else
            @props.onChange(null)

      else
        widget = uploadcare.Widget($ucInput)
        widget.onChange (file) =>
          if (file)
            file.done (info) =>
              @props.onChange(cleanInfo(info))
          else
            @props.onChange(null)

    render: ->
      React.DOM.div()
