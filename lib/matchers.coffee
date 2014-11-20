###*
# Provides methods to check for different "line types" (comment, empty...)
# and to get their contents.
#
# NOTE: Strings are trimmed before trying the match against those RegExp.
# So they don't care about whitespace at the beginning or the end of the input.
# @class Matcher
# @static
###

class Matcher
	###*
	# Checks if a string constains only white space.
	# @property emptyLineMatcher
	# @type RegExp
	###
	emptyLineMatcher = /^\s*$/

	###*
	# Matches new line characters.
	# @property newLineMatcher
	# @type RegExp
	###
	newlineMatcher = /[\r\n]+/g

	###*
	# Matches strings of type "comment".
	# A comment has the following features:
	#
	# 	-starts with #
	# @property commentLineMatcher
	# @type RegExp
	###
	commentLineMatcher = /^#/

	###*
	# Extracts content from strings of type "comment".
	# See {{#crossLink "Matcher/commentLineMatcher:property"}}{{/crossLink}}
	# @property commentMatcher
	# @type RegExp
	###
	commentMatcher = /^#(.*)$/i

	###*
	# Matches strings of type "section header".
	# A section header has the following features:
	#
	#	-starts with [
	#
	#	-ends with ]
	#
	# 	-between those 2 symbols it must contain just a
	# valid javascript object key, although it can be surrounded by whitespace.
	#
	# [HEADER] => it's a header
	# [ HEADER ] => it's a header
	# [ HEADER_NAME ] => it's a header
	# [ HEADER.NAME ] => it's a header
	# [ HEADER NAME ] => it's NOT a header
	#
	# @property sectionHeaderMatcher
	# @type RegExp
	###
	sectionHeaderMatcher = /^\[(\s*[a-zA-Z_][a-zA-Z0-9._]*\s*)\]$/i

	# A key=value line:
	#	-starts with a valid javascript key
	#	-continues with a =
	#	-ends with any combination of characters
	# key=value => it's a key/value line
	# key = value => it's a key/value line
	# key.subkey = value => it's a key/value line
	# key = value includes a second = but and it's fine => it's a key/value line
	# 1key=value => it's NOT a key/value line
	# key subkey = value => it's NOT a key/value line
	keyValueMatcher = /^([a-zA-Z_][a-zA-Z0-9._]*\s*\=.*)$/i

	keyMatcher = /^([a-zA-Z_][a-zA-Z0-9._]*\s*)\=/i

	valueMatcher = /^[a-zA-Z_][a-zA-Z0-9._]*\s*\=(.*)$/i

	@splitOnNewLine = (text) ->
		return text.split newlineMatcher

	@isEmpty = (text) ->
		return emptyLineMatcher.test text.trim()

	@isComment = (text) ->
		return commentLineMatcher.test text.trim()

	@getComment = (text) ->
		if not @isComment text
			return null
		else
			return text.trim().match(commentMatcher)[1].trim()

	@isSectionHeader = (text) ->
		return sectionHeaderMatcher.test text.trim()

	@getSectionHeader = (text) ->
		if not @isSectionHeader text
			return null
		else
			return text.trim().match(sectionHeaderMatcher)[1].trim()

	@isKeyValue = (text) ->
		return keyValueMatcher.test text.trim()

	@getKey = (text) ->
		if not @isKeyValue text
			return null
		else
			return text.trim().match(keyMatcher)[1].trim()

	@getValue = (text) ->
		if not @isKeyValue text
			return null
		else
			return text.trim().match(valueMatcher)[1].trim()

module.exports = Matcher