module.exports =
  index: (req, res) ->
    res.render 'index', title: 'kaosfield.net'
    return
  log:
    index: (req, res) ->
      res.render 'log/index', title: 'kaosfield.net'
      return
