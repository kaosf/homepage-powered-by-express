exports.index = (req, res) ->
  res.render 'index', title: 'kaosfield.net'

exports.log =
  index: (req, res) ->
    res.render 'log/index', title: 'kaosfield.net'
