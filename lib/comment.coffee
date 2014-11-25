matchers = require './matchers'
Line = require './line'

###*
# Class type for strings that are comments.
#
# @class Comment
# @extends Line
###

class Comment extends Line
	###*
	# Returns a string identifying the type of the class: Comment
	#
	# @method getType
	# @return {String} The type of the class.
	###
	getType: ->
		return 'Comment'

	###*
	# Returns a Function that matches the string type markers of this type.
	#
	# @method getTypeMatcher
	# @return {Function} Function to be executed to check if string
	# 					 conforms to type.
	###
	getTypeMatcher: ->
		return matchers.isComment

	###*
	# Returns a Function that returns the content of the string
	# with the string type markers of this type removed.
	#
	# @method getContentExtractor
	# @return {Function} Function to be executed to get the content.
	###
	getContentExtractor: ->
		return matchers.getComment

module.exports = Comment