{isObject} = require 'underscore'
{ResponseSpecification} = require './responder'
url = require 'url'

class Dsl
  constructor: (@_addResponseSpecification, [@_path]) ->
    @_withMode = 'replaceContent'

  byReplacing: (key) ->
    @_withMode = 'replaceKey'
    @_key = key
    this

  with: (what) ->
    if isObject what
      {body, statusCode} = what
    else
      body = what
      statusCode = 200

    {pathname, query} = url.parse @_path, true

    spec = switch @_withMode
      when 'replaceContent'
        path: pathname
        method: 'GET'
        query: query
        body: body
        statusCode: statusCode
      when 'replaceKey'
        path: pathname
        method: 'GET'
        query: query
        replaceKey: @_key
        replaceValue: what
    @_addResponseSpecification spec

module.exports = Dsl
