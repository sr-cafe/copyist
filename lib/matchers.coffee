###*
# Provides methods to check for different "line types" (comment, empty...)
# and to get their contents.
#
# Strings are trimmed before trying the match against those RegExp.
# So they don't care about whitespace at the beginning or the end of the input.
# @class Matcher
# @static
###

class Matcher
	###*
	# Checks if a string constains only white space.
	#
	# @property emptyLineMatcher
	# @type RegExp
	###
	emptyLineMatcher = /^\s*$/

	###*
	# Matches new line characters.
	#
	# @property newLineMatcher
	# @type RegExp
	###
	newlineMatcher = /[\r\n]+/g

	###*
	# Matches strings of type "comment".
	#
	# A comment has the following features:
	#
	# -starts with #
	#
	# @property commentLineMatcher
	# @type RegExp
	###
	commentLineMatcher = /^#/

	###*
	# Extracts content from strings of type "comment".
	#
	# See {{#crossLink "Matcher/commentLineMatcher:property"}}{{/crossLink}}
	#
	# @property commentExtractor
	# @type RegExp
	###
	commentExtractor = /^#(.*)$/i

	###*
	# Matches strings of type "command".
	#
	# A command has the following features:
	#
	# -starts with !#
	#
	# @property commandLineMatcher
	# @type RegExp
	###
	commandLineMatcher = /^!#/

	###*
	# Extracts content from strings of type "command".
	#
	# See {{#crossLink "Matcher/commandLineMatcher:property"}}{{/crossLink}}
	#
	# @property commandExtractor
	# @type RegExp
	###
	commandExtractor = /^!#(.*)$/i

	###*
	# Matches strings of type "section header".
	#
	# A section header has the following features:
	#
	# -starts with [
	#
	# -ends with ]
	#
	# -between those 2 symbols it must contain just a
	# valid javascript object key, although it can be surrounded by whitespace.
	#
	# Examples:
	#
	# [HEADER] => it's a header
	#
	# [ HEADER ] => it's a header
	#
	# [ HEADER_NAME ] => it's a header
	#
	# [ HEADER.NAME ] => it's a header
	#
	# [ HEADER NAME ] => it's NOT a header
	#
	# @property sectionHeaderMatcher
	# @type RegExp
	###
	sectionHeaderMatcher = /^\[(\s*[a-zA-Z_][a-zA-Z0-9._]*\s*)\]$/i

	###*
	# Matches strings of type "key=value".
	#
	# A key=value line:
	#
	#-starts with a valid javascript key
	#
	#-continues with a =
	#
	#-ends with any combination of characters
	#
	# Examples:
	#
	# key=value => it's a key/value line
	#
	# key = value => it's a key/value line
	#
	# key.subkey = value => it's a key/value line
	#
	# key = value includes a second = and it's fine => it's a key/value line
	#
	# 1key=value => it's NOT a key/value line
	#
	# key subkey = value => it's NOT a key/value line
	#
	# @property keyValueMatcher
	# @type RegExp
	###
	keyValueMatcher = /^([a-zA-Z_][a-zA-Z0-9._]*\s*\=.*)$/i

	###*
	# Extracts the key fragment from strings of type "key=value".
	#
	# See {{#crossLink "Matcher/keyValueMatcher:property"}}{{/crossLink}}
	#
	# @property keyExtractor
	# @type RegExp
	###
	keyExtractor = /^([a-zA-Z_][a-zA-Z0-9._]*\s*)\=/i

	###*
	# Extracts the value fragment from strings of type "key=value".
	#
	# See {{#crossLink "Matcher/keyValueMatcher:property"}}{{/crossLink}}
	#
	# @property valueExtractor
	# @type RegExp
	###
	valueExtractor = /^[a-zA-Z_][a-zA-Z0-9._]*\s*\=(.*)$/i

	###*
	# Splits a string using newline characters as separator.
	#
	# @method splitOnNewLine
	# @param {String} text The string to be divided.
	#
	# @return {Array} Array of substrings.
	###
	@splitOnNewLine = (text) ->
		return text.split newlineMatcher

	###*
	# Checks wether a string contains only white space.
	#
	# @method isEmpty
	# @param {String} text The string to be checked.
	#
	# @return {Boolean} True if the string contains only white space.
	###
	@isEmpty = (text) ->
		return emptyLineMatcher.test text.trim()

	###*
	# Checks wether a string is of type "comment".
	#
	# @method isComment
	# @param {String} text The string to be checked.
	#
	# @return {Boolean} True if the string is of type "comment".
	###
	@isComment = (text) ->
		return commentLineMatcher.test text.trim()

	###*
	# Returns the content of a string of type "comment".
	#
	# @method getComment
	# @param {String} text The string from which fragment must be extracted.
	#
	# @return {String} Content fragment of the string. Null if string is not
	# a comment.
	###
	@getComment = (text) ->
		if not @isComment text
			return null
		else
			return text.trim().match(commentExtractor)[1].trim()

	###*
	# Checks wether a string is of type "command".
	#
	# @method isCommand
	# @param {String} text The string to be checked.
	#
	# @return {Boolean} True if the string is of type "command".
	###
	@isCommand = (text) ->
		return commandLineMatcher.test text.trim()

	###*
	# Returns the content of a string of type "command".
	#
	# @method getCommand
	# @param {String} text The string from which fragment must be extracted.
	#
	# @return {String} Content fragment of the string. Null if string is not
	# a command.
	###
	@getCommand = (text) ->
		if not @isCommand text
			return null
		else
			return text.trim().match(commandExtractor)[1].trim()

	###*
	# Checks wether a string is of type "section header".
	#
	# @method isSectionHeader
	# @param {String} text The string to be checked.
	#
	# @return {Boolean} True if the string is of type "section header".
	###
	@isSectionHeader = (text) ->
		return sectionHeaderMatcher.test text.trim()

	###*
	# Returns the content of a string of type "section header".
	#
	# @method getSectionHeader
	# @param {String} text The string from which fragment must be extracted.
	#
	# @return {String} Content fragment of the string. Null if string is not
	# a section header.
	###
	@getSectionHeader = (text) ->
		if not @isSectionHeader text
			return null
		else
			return text.trim().match(sectionHeaderMatcher)[1].trim()

	###*
	# Checks wether a string is of type "key=value".
	#
	# @method isKeyValue
	# @param {String} text The string to be checked.
	#
	# @return {Boolean} True if the string is of type "key=value".
	###
	@isKeyValue = (text) ->
		return keyValueMatcher.test text.trim()

	###*
	# Returns the key fragment of a string of type "key=value".
	#
	# @method getKey
	# @param {String} text The string from which fragment must be extracted.
	#
	# @return {String} Content fragment of the string. Null if string is not
	# a key=value string.
	###
	@getKey = (text) ->
		if not @isKeyValue text
			return null
		else
			return text.trim().match(keyExtractor)[1].trim()

	###*
	# Returns the value fragment of a string of type "key=value".
	#
	# @method getValue
	# @param {String} text The string from which fragment must be extracted.
	#
	# @return {String} Content fragment of the string. Null if string is not
	# a key=value string.
	###
	@getValue = (text) ->
		if not @isKeyValue text
			return null
		else
			return text.trim().match(valueExtractor)[1].trim()

module.exports = Matcher