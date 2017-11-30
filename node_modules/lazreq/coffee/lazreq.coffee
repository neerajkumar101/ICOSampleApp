
parse_stack = null

loaded    = {}
requested = {}


find_module = (filename) ->
  modules = {}

  search = (nodes) ->
    for node in nodes when not modules[node.filename]
      if filename is node.filename
        return node
      modules[node.filename] = node
      if node.children and resolved = search node.children
        return resolved
    null

  search [process.mainModule]


lazreq = (inf) ->
  caller_module = null

  id_origin = ->
    unless parse_stack
      parse_stack = require 'parse-stack'

    try
      stack = parse_stack new Error 'fake'
    catch err
      throw new Error 'Standard node.js stack trace API support is required'

    unless caller_module = find_module stack[2].filepath
      throw new Error 'Could not identify caller module'

  for name, ref of inf when not requested.hasOwnProperty name
    unless caller_module
      id_origin()

    do (name, ref) ->
      Object.defineProperty requested, name,
        configurable: false
        enumerable:   true
        get: ->
          unless loaded.hasOwnProperty name
            loaded[name] = caller_module.require ref
          loaded[name]

  requested


module.exports = lazreq
