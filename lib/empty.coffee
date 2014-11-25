matchers = require './matchers'
Line = require './line'

###*
# Class type for strings that are empty: only contain white space.
#
# @class Empty
# @extends Line
###
class Comment extends Line
	###*
	# Returns a string identifying the type of the class: Empty
	#
	# @method getType
	# @return {String} The type of the class.
	###
	getType: ->
		return 'Empty'

	###*
	# Returns a Function that matches the string type markers of this type.
	#
	# @method getTypeMatcher
	# @return {Function} Function to be executed to check if string
	# 					 conforms to type.
	###
	getTypeMatcher: ->
		return matchers.isEmpty

	###*
	# Returns a Function that returns the original string (an empty string).
	#
	# @method getContentExtractor
	# @return {Function} Function to be executed to get the original string.
	###
	getContentExtractor: ->
		return ->
			return @_data.raw

module.exports = Comment