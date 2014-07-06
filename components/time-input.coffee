# depends on
#    moment.js

(exports) ->
  val = (event) -> event.target.value
  valNum = (event) -> +val(event).replace(/[^0-9]/g, '')
  minMax = (min, max, cur) -> Math.max(min, Math.min(max, cur))


  exports.TimeField = React.createClass
    getInitialState: ->
      m = moment(@props.time)
      {
        year: m.year()
        month: m.month() + 1
        day: m.date() + 1
        hour: m.hour()
        minute: m.minute()
      }
    componentWillReceiveProps: (props) ->
      m = moment(props.time)
      @setState({
        year: m.year()
        month: m.month() + 1
        day: m.date()
        hour: m.hour()
        minute: m.minute()
      })
    handleYear: (event) -> @setState(year: valNum(event))
    handleMonth: (event) -> @setState(month: valNum(event))
    handleDay: (event) -> @setState(day: valNum(event))
    handleHour: (event) -> @setState(hour: valNum(event))
    handleMinute: (event) -> @setState(minute: valNum(event))
    reportYear: -> @reportChange('year', minMax(2000, 2100, @state.year))
    reportMonth: -> @reportChange('month', minMax(1, 12, @state.month) - 1)
    reportDay: -> @reportChange('date', minMax(1, 31, @state.day))
    reportHour: -> @reportChange('hour', minMax(0, 23, @state.hour))
    reportMinute: -> @reportChange('minute', minMax(0, 59, @state.minute))
    reportChange: (field, value) ->
      m = moment(@props.time)
      m[field](value)
      @props.onChange(1000 * m.format('X'))
    render: ->
      React.DOM.div({className: 'time-field'},
        React.DOM.input(type: 'text', placeholder: "гггг", className: 'time-field__year', value: @state.year, onChange: @handleYear, onBlur: @reportYear)
        "/"
        React.DOM.input(type: 'text', placeholder: "мм", className: 'time-field__month', value: @state.month, onChange: @handleMonth, onBlur: @reportMonth)
        "/"
        React.DOM.input(type: 'text', placeholder: "дд", className: 'time-field__day', value: @state.day, onChange: @handleDay, onBlur: @reportDay)
        ", "
        React.DOM.input(type: 'text', placeholder: "чч", className: 'time-field__hour', value: @state.hour, onChange: @handleHour, onBlur: @reportHour)
        ":"
        React.DOM.input(type: 'text', placeholder: "мм", className: 'time-field__minute', value: @state.minute, onChange: @handleMinute, onBlur: @reportMinute)
      )
