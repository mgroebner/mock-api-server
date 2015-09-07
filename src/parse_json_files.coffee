grabAllLines = (fileContent) ->
  fileContent.toString('utf-8').split("\n")

parseStatusCode = (line) ->
  if line.match(/\d{3}/)
    line.match(/\d{3}/)[0]

module.exports = (fileHash) ->
  responseHash = {}

  for path, contents of fileHash
    lines = grabAllLines(contents)

    if lines[0].indexOf('{') == -1
      firstLine = lines.shift()
      secondLine = lines.shift()
      statusCode = parseStatusCode(firstLine)
    else
      statusCode = 200
    try
      body = JSON.parse lines.join("\n")
    catch error
      throw Error error + '\n while parsing path: ' + path
    

    responseHash[path] = { statusCode, body }

  responseHash