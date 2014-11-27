util = require 'util'
matchers = require './matchers'

CommandLine = require './command'
CommentLine = require './comment'
EmptyLine = require './empty'
KeyValueLine = require './key_value'
PlainLine = require './plain'

class Copyist
	###*
	# Copyist is responsible for turning a string into an array of Line
	# objects (one for every line) and return their data in a convenient format.
	#
	# @class Copyist
	# @constructor
	# @param {String} [src] String to parse.
	###
	constructor: (@src) ->
		@lineBreakReplacement = '<br />'

	###*
	# Especifies how to replace line breaks.
	#
	# @method newline
	# @param {String} lineBreakReplacement Characters used to mark line breaks.
	# @return {Copyist} This instance.
	###
	newline: (@lineBreakReplacement) ->
		@lines.map addLineBreakReplacement @lineBreakReplacement

		return this

	###*
	# Converts the supplied string into Line objects.
	#
	# @method parse
	# @param {String} [src=@src] String to parse.
	# @return {Copyist} This instance.
	###
	parse: (@src = @src) ->
		@lines = matchers.splitOnNewLine @src
			.map createLine
			.map mergeMultilineContent()

		@lines.filter filterWith 'KeyValue'
			.map consolidateMultilineContent

		@newline @lineBreakReplacement

		return this

	###*
	# Returns a javascript object which contains the document texts under
	# their respective keys.
	#
	# @method pojo
	# @param {Object} [result={}] Object to store the parse result.
	# @return {Object} Object storing texts.
	###
	pojo: (result = {})->
		return buildPOJO(@lines, result)

	###*
	# Returns the array of Line objects that represents the whole document.
	#
	# @method lines
	# @return {Array} Array of Lines.
	###
	lines: ->
		return @lines

	###*
	# Returns the original string.
	#
	# @method raw
	# @return {String} The original string.
	###
	raw: ->
		return @src

	###*
	# Returns an array containing only Comment objects.
	#
	# @method comments
	# @return {Array} Array of Comments.
	###
	comments: ->
		return @lines.filter filterWith 'Comment'


#######################################################################
#	PRIVATE UTILITY METHODS
#######################################################################
createLine = (line, index) ->
	if matchers.isEmpty line
		instance = new EmptyLine line, index

	if matchers.isCommand line
		instance = new CommandLine line, index

	if matchers.isComment line
		instance = new CommentLine line, index

	if matchers.isKeyValue line
		instance = new KeyValueLine line, index

	# If no matcher fits we assume it's a line from a multiline content.
	unless instance
		instance = new PlainLine line, index

	return instance

mergeMultilineContent = () ->
	lastContentLine = null
	return (line) ->
		if line.getType() is 'Empty' or line.getType() is 'Plain'
			lastContentLine.addLine line if lastContentLine

		if line.getType() is 'KeyValue'
			lastContentLine = line

		return line

consolidateMultilineContent = (line) ->
	line.consolidateMultiline()

addLineBreakReplacement = (replacement) ->
	return (line) ->
		line.newline replacement
		return line

addLineToObject = (obj) ->
	lastContentLine = null

	return (line) ->
		if line.getType() is 'KeyValue'
			keys = line.key().split '.'
			content = line.value()

			if keys.length is 1
				node = addNode obj, keys[0], content
			else
				leaf = obj
				for key in keys.splice 0, keys.length - 1
					if not leaf[key]
						leaf[key] = {}
					leaf = leaf[key]
				node = addNode leaf, keys[keys.length - 1], content

			lastContentLine = line

		return line

addNode = (node, key, content) ->
	if key of node
		isArr = util.isArray node[key]
		if not isArr
			node[key] = [node[key]]
		node[key].push content
	else
		node[key] = content
	return node

filterWith = (type) ->
	return (line) ->
		return line.getType() is type

buildPOJO = (lines, result) ->
	lines.filter filterWith 'KeyValue'
		.map addLineToObject result

	return result

module.exports = Copyist