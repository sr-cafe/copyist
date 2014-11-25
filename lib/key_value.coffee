matchers = require './matchers'
Line = require './line'

###*
# Class type for strings that contain data in key=value format.
#
# @class KeyValue
# @extends Line
###
class KeyValue extends Line

	###*
	# Constructor.
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

module.exports = KeyValue