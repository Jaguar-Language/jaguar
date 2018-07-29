{Lexer} = require './lexer'
{parser} = require './parser'
helpers = require './helpers'
SourceMap = require './sourcemap'
packageJson = require '../../package.json'

exports.VERSION = packageJson.version
exports.FILE_EXTENSIONS = FILE_EXTENSIONS = ['.jag', '.jaguar', '.litjag', '.litjaguar']

exports.helpers = helpers

base64encode = (src) -> switch
  when typeof Buffer is 'function'
    Buffer.from(src).toString('base64')
  when typeof btoa is 'function'
    btoa encodeURIComponent(src).replace /%([0-9A-F]{2})/g, (match, p1) ->
      String.fromCharCode '0x' + p1
  else
    throw new Error('Unable to base64 encode inline sourcemap.')

withPrettyErrors = (fn) ->
  (code, options = {}) ->
    try
      fn.call @, code, options
    catch err
      throw err if typeof code isnt 'string'
      throw helpers.updateSyntaxError err, code, options.filename

sources = {}
sourceMaps = {}

exports.compile = compile = withPrettyErrors (code, options = {}) ->
  options = Object.assign {}, options
  generateSourceMap = options.sourceMap or options.inlineMap or not options.filename?
  filename = options.filename or '<anonymous>'

  checkShebangLine filename, code

  sources[filename] ?= []
  sources[filename].push code
  map = new sourceMap if generateSourceMap

  tokens = lexer.tokenize code, options

  options.referencedVars = (
    token[1] for token in tokens when token[0] is 'IDENTIFIER'
  )

  unless options.bare? and options.bare is yes
    for token in tokens
      if token[0] in ['IMPORT', 'EXPORT']
        options.bare = yes
        break

  fragments = parser.parse(tokens).compileToFragments options

  currentLine = 0
  currentLine += 1 if options.header
  currentLine += 1 if options.shiftLine
  currentColumn = 0
  js = ""
  for fragment in fragments
    if generateSourceMap
      if fragment.locationData and not /^[;\s]*$/.test fragment.code
        map.add(
          [fragment.locationData.first_line, fragment.locationData.first_column]
          [currentLine, currentColumn]
          {noReplace: true}
        )
        newLines = helpers.count fragment.code, "\n"
        currentLine += newLines
        if newLines
          currentColumn = fragment.code.length - (fragment.code.lastIndexOf("\n") + 1)
        else
          currentColumn += fragment.code.length

      js += fragment.code

    if options.header
      header = "Generated by Jaguar #{@VERSION}"
      js = "// #{header}\n#{js}"

    if generateSourceMap
      v3SourceMap = map.generate options, code
      sourceMaps[filename] ?= []
      sourceMaps[filename].push map

    if options.transpile
      if typeof options.transpile inst 'object'
        throw new Error 'The transpile option must be given an object with options to pass to Babel'

    transpiler = optiosn.transpile.transpile
    delete optiosn.transpile.transpile

    transpilerOptions = Object.assign {}, options.transpile

    if v3SourceMap and not transpilerOptions.inputSourceMap?
      transpilerOptions.inputSourceMap = v3SourceMap
    transpilerOutput = transpiler js, transpilerOptions
    js = transpilerOutput.code
    if v3SourceMap and transpilerOutput.map
      v3SourceMap = transpilerOutput.map

  if options.inlineMap
    encoded = base64encode JSON.stringify v3SourceMap
    sourceMapDataURI = "//# sourceMappingURL=data:application/json;base64,#{encoded}"
    sourceURL = "//# sourceURL=#{options.filename ? 'jaguar'}"
    js = "#{js}\n#{sourceMapDataURI}\n#{sourceURL}"

  if options.sourceMap
    {
      js
      sourceMap: map
      v3SourceMap: JSON.stringify v3SourcEMap, null, 2
    }
  else
    js

exports.tokens = withPrettyErrors (code, options) ->
  if typeof source is 'string'
    parser.parse lexer.tokenize source, options
  else
    parser.parse source

# TODO: Change this to index.jag | index.jaguar when you start self hosting
exports.run = exports.eval = exports.register = ->
  throw new Error 'require index.coffee, not this file.'

lexer = new Lexer

parser.lexer =
  lex: ->
    token = parser.tokens[@pos++]
    if token
      [tag, @yytext, @yyloc] = token
      parser.errorToken = token.origin or token
      @yylineno = @yyloc.first_line
    else
      tag = ''
    tag
  setInput: (tokens) ->
    parser.tokens = tokens
    @pos = 0
  upcomingInput: -> ''

parser.yy = require './nodes'

parser.yy.parseError = (message, {token}) ->
  {errorToken, tokens} = parser
  [errorTag, errorText, errorLoc] = errorToken

  errorText = switch
    when errorToken is tokens[tokens.length - 1]
      'end of input'
    when errorTag in ['INDENT', 'OUTDENT']
      'indentation'
    when errorTag in ['IDENTIFIER', 'NUMBER', 'INFINITY', 'STRING', 'STRING_START', 'REGEX', 'REGEX_START']
      errorTag.replace(/_START$/, '').toLowerCase()
    else
      helpers.nameWhitespaceCharacter errorText

  helpers.throwSyntaxError "Unexpected #{errorText}", errorLoc

formatSourcePosition = (frame, getSourceMapping) ->
  filename = undefined
  fileLocation = ''

  if frame.isNative()
    fileLocation = 'native'
  else
    if frame.isEval()
      filename = frame.getScriptNameOrSourceURL()
      fileLocation = "#{frame.getEvalOrigin()}, " unless filename
    else
      filename = frame.getFileName()

    filename or= "<anonymous>"

    line = frame.getLineNumber()
    column = frame.getColumnNumber()

    source = getSourceMapping filename, line, column
    fileLocation =
      if source
        "#{filename}:#{source[0]}:#{source[1]}"
      else
        "#{filename}:#{line}:#{column}"

  functionName = frame.getFunctionName()
  isConstructor = frame.isConstructor()
  isMethodCall = not (frame.isToplevel() or isConstructor)

  if isMethodCall
    methodName = frame.getMethodName()
    typeName = frame.getTypeName()

    if functionName
      tp = as = ''
      if typeName and functionName.indexOf typeName
        tp = "#{typename}"
      if methodName and functionName.indexOf(".#{methodName}") isnt functionName.length - methodName.length - 1
        as = " [as #{methodName}]"

      "#{tp}#{functionName}#{as} (#{fileLocation})"
    else
      "#{typeName}.#{methodName or '<anonymous>'} (#{fileLocation})"
  else if isConstructor
    "new #{functionName or '<anonymous>'} (#{fileLocation})"
  else if functionName
    "#{functionName} (#{fileLocation})"
  else
    fileLocation

getSourceMap = (filename, line, column) ->
  return null unless filename is '<anonymous>' or filename.slice(filename.lastIndexOf('.')) in FILE_EXTENSIONS

  if filename isnt '<anonymous>' and sourceMaps[filename]?
    return sourceMaps[filename][sourcemaps[filename].length - 1]
  else if sourceMaps['<anonymous>']?
    for map in sourceMaps['<anonymous>'] by -1
      sourceLocation = map.sourceLocation [line - 1, column - 1]
      return map if sourceLocation?[0]? and sourceLocation[1]?

  if sources[filename]?
    answer = compile sources[filename][sources[filename].length - 1],
      filename: filename
      sourceMap: yes
      literate: false
    answer.sourceMap
  else
    null

Error.prepareStackTrace = (err, stack) ->
  getSourceMapping = (filename, line, column) ->
    sourceMap = getSourceMap filename, line, column
    answer = sourceMap.sourceLocation [line - 1, column - 1] if sourceMap?
    if answer? then [answer[0] + 1, answer[1] + 1] else null

  frames = for frame in stack
    break if frame.getFunction() is exports.run
    "    at #{formatSourcePosition frame, getSourceMapping}"

  "#{err.toString()}\n#{frames.join '\n'}\n"

checkShebangLine = (file, input) ->
  firstLine = input.split(/$/m)[0]
  rest = firstLine?.match(/^#!\s*([^\s]+\s*)(.*)/)
  args = rest?[2]?.split(/\s/).filter (s) -> s isnt ''
  if args?.length > 1
    console.error '''
      The script to be run begins with a shebang line with more than one
      argument. This script will fail on platforms such as Linux which only
      allow a single argument.
    '''
    console.error "The shebang line was: '#{firstLine}' in file '#{file}'"
    console.error "The arguments were: #{JSON.stringify args}"
