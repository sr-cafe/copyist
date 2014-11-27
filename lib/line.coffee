class Line
	###*
	# Base class for text lines.
	#
	# A Line transforms a string into a data structure
	# which contains at least:
	#
	# - lineNumber: Position of the string in the document.
	#
	# - value: Content of the string with string type markers removed.
	# A string type marker is a combination of characters that define which
	# type of string they are on. For instance, "#" at the beginning of the
	# string marks it as a comment.
	#
	# - raw: The original content of the line.
	#
	# Line acts as an abstract class, so it cannot be instantiated directly.
	#
	# @class Line
	# @constructor
	# @param {String} text String to parse.
	# @param {Number} lineNumber Position of the string in the document.
	###
	constructor: (text, lineNumber) ->
		if Line.prototype.constructor is @constructor
			throw new Error 'Line class must be subclassed.'

		if not @checkType text
			throw new Error "Line #{lineNumber} (#{text})
							is not of type #{@getType()}"

		@_data =
			lineNumber: lineNumber
			raw: text
			value: @parse text

		@lines = []
		@lineBreakReplacement = '<br />'

	###*
	# Checks if the text provided conforms to the string type.
	#
	# @method checkType
	# @param {String} text String passed to the Line object.
	# @return {Boolean} True if text conforms to the string type.
	###
	checkType: (text) ->
		return @getTypeMatcher() text

	###*
	# Gets the content of the string without string type markers.
	#
	# @method parse
	# @param {String} text String to extract content from.
	# @return {String} Content without string type markers.
	###
	parse: (text) ->
		return @getContentExtractor() text

	###*
	# Adds a new line to the content.
	#
	# @method addLine
	# @param {Line} Line to be added
	###
	addLine: (line)->
		@lines.push line

	###*
	# Especifies how to replace line breaks.
	#
	# @method newline
	# @param {String} lineBreakReplacement Characters used to mark line breaks.
	###
	newline: (@lineBreakReplacement)->


	#######################################################################
	#	GETTERS
	#######################################################################
	###*
	# Getter for the line number property.
	#
	# @method lineNumber
	# @return {Number} Position of the line in the document.
	###
	lineNumber: ->
		return @_data.lineNumber

	###*
	# Getter for the original string.
	#
	# @method raw
	# @return {String} Original string.
	###
	raw: ->
		return @_data.raw

	###*
	# Getter for the value property: the content of the string with
	# string type markers removed.
	#
	# @method value
	# @return {String} String with string type markers removed.
	###
	value: ->
		return @_data.value

	###*
	# Getter for the data structure.
	#
	# @method data
	# @return {Object} Data belonging to this instance.
	###
	data: ->
		return @_data

	#######################################################################
	#	METHODS TO OVERRIDE
	#######################################################################
	###*
	# This method must be overriden.
	#
	# Returns a string identifying the type of the class
	# (Comment, KeyValue...)
	#
	# @method getType
	# @return {String} The type of the class.
	###
	getType: ->
		throw new Error getOverrideError 'getType'

	###*
	# This method must be overriden.
	#
	# Returns a Function that matches the string type markers of this type.
	#
	# @method getTypeMatcher
	# @return {Function} Function to be executed to check if string
	# 					 conforms to type.
	###
	getTypeMatcher: ->
		throw new Error getOverrideError 'getTypeMatcher'

	###*
	# This method must be overriden.
	#
	# Returns a Function that returns the content of the string
	# with the string type markers of this type removed.
	#
	# @method getContentExtractor
	# @return {Function} Function to be executed to get the content.
	###
	getContentExtractor: ->
		throw new Error getOverrideError 'getContentExtractor'

	#######################################################################
	#	PRIVATE UTILITY METHODS
	#######################################################################

	###*
	# Default error message for methods not overriden.
	# @property
	# @private
	###
	METHOD_NOT_OVERRIDEN = 'Method {m} must be overriden in subclass'

	###*
	# Returns a string with the method who caused the error interpolated.
	#
	# @method
	# @private
	# @param {String} methodName Name of the method not overriden.
	###
	getOverrideError = (methodName) ->
		return METHOD_NOT_OVERRIDEN.replace '{m}', methodName

module.exports = Line