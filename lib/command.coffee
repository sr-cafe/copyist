matchers = require './matchers'
Line = require './line'

###*
# Class type for strings that contain a command.
#
# A command is a special instruction regarding a line of the document
# that should be performed by whoever is consuming it.
#
#
# Since the document format is flat (no nested elements), it can lead to some
# ambiguous situations.
#
# Take the next 2 lines, for example:
#
# menu.item.name = A
#
# menu.item.name = B
#
# It's not clear if we are dealing with 1 item that has 2 names or with 2 items
# each one having a name.
#
# By default, Copyist will turn the last key into an array:
#
# menu.item.name = ['A', 'B']
#
# This doesn't seem the appropiate outcome in this case,
# so we can use a Command to explain our intentions to the parser:
#
# !# [] :: menu.item
#
# This line is telling the parser that the key "menu.item"
# must be converted to an array ([]), thus yielding:
#
# menu.item = [{name:'A'}, {name:'B'}]
#
# @class Command
# @extends Line
###

class Command extends Line
	###*
	# Returns a string identifying the type of the class: Command
	#
	# @method getType
	# @return {String} The type of the class.
	###
	getType: ->
		return 'Command'

	###*
	# Returns a Function that matches the string type markers of this type.
	#
	# @method getTypeMatcher
	# @return {Function} Function to be executed to check if string
	# 					 conforms to type.
	###
	getTypeMatcher: ->
		return matchers.isCommand

	###*
	# Returns a Function that returns the content of the string
	# with the string type markers of this type removed.
	#
	# @method getContentExtractor
	# @return {Function} Function to be executed to get the content.
	###
	getContentExtractor: ->
		return matchers.getCommand

module.exports = Command