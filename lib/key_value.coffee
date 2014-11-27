matchers = require './matchers'
Line = require './line'

class KeyValue extends Line
	###*
	# Class type for strings that contain data in key=value format.
	#
	# @class KeyValue
	# @extends Line
	#
	# @constructor
	# @param {String} text String to parse.
	# @param {Number} lineNumber Position of the string in the document.
	###
	constructor: (text, lineNumber) ->
		super text, lineNumber

		@_data.key = matchers.getKey text

	###*
	# Getter for the key property.
	#
	# @method key
	# @return {String} Key fragment of the original string.
	###
	key: ->
		return @_data.key

	###*
	# Returns a string identifying the type of the class: KeyValue
	#
	# @method getType
	# @return {String} The type of the class.
	###
	getType: ->
		return 'KeyValue'

	###*
	# Returns a Function that matches the string type markers of this type.
	#
	# @method getTypeMatcher
	# @return {Function} Function to be executed to check if string
	# 					 conforms to type.
	###
	getTypeMatcher: ->
		return matchers.isKeyValue

	###*
	# Returns a Function that returns the content of the string
	# with the string type markers of this type removed.
	#
	# @method getContentExtractor
	# @return {Function} Function to be executed to get the content.
	###
	getContentExtractor: ->
		return matchers.getValue

	###*
	# Getter for the value property: the content of the string with
	# string type markers removed.
	# If content spawned between multiple lines, it will return a string
	# with all lines joined by the specified line break replacement.
	#
	# @method value
	# @return {String} String with string type markers removed.
	###
	value: ->
		values = @lines.map (line) ->
			return line.value()

		return [@_data.value].concat(values).join(@lineBreakReplacement)

	###*
	# Merges new lines with the original content.
	#
	# @method consolidateMultiline
	###
	consolidateMultiline: ->
		index = @lines.length - 1

		while @lines.length > 0 and @lines[index].getType() is 'Empty'
			@lines.pop()
			index--

module.exports = KeyValue