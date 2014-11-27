matchers = require './matchers'
Line = require './line'

###*
# Class type for strings that are just text from multiline content.
#
# @class Plain
# @extends Line
###

class PlainLine extends Line
	###*
	# Returns a string identifying the type of the class: Plain
	#
	# @method getType
	# @return {String} The type of the class.
	###
	getType: ->
		return 'Plain'

	###*
	# Returns a Function that matches the string type markers of this type.
	#
	# @method getTypeMatcher
	# @return {Function} Function to be executed to check if string
	# 					 conforms to type.
	###
	getTypeMatcher: ->
		return ->
			return true

	###*
	# Returns a Function that returns the original string.
	#
	# @method getContentExtractor
	# @return {Function} Function to be executed to get the original string.
	###
	getContentExtractor: ->
		return (text) ->
			return text.trim()


module.exports = PlainLine