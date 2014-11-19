emptyLineMatcher = /^\s*$/

newlineMatcher = /[\r\n]+/g

# NOTE: Lines are trimmed before trying the match against those RegExp.
# So they don't care about whitespace at the beginning or the end of the input.

# A comment:
# 	-starts with #
commentLineMatcher = /^#/

# A section header:
#	-starts with [
#	-ends with ]
# 	-between those 2 symbols it can contain just a valid javascript object key, although it can be surrounded by whitespace
# [HEADER] => it's a header
# [ HEADER ] => it's a header
# [ HEADER_NAME ] => it's a header
# [ HEADER.NAME ] => it's a header
# [ HEADER NAME ] => it's NOT a header
sectionHeaderMatcher = /^\[(\s*[a-zA-Z_][a-zA-Z0-9._]*\s*)\]$/i;

# A key=value line:
#	-starts with any combination of characters than doesn't contain any whitespace
#	-continues with a =
#	-ends with any combination of characters
# key=value => it's a key/value line
# key = value => it's a key/value line
# key.subkey = value => it's a key/value line
# key = value includes a second = but and it's fine => it's a key/value line
# key subkey = value => it's NOT a key/value line
keyValueMatcher = /^(\S*\s*\=.*)$/i

module.exports =
	splitOnNewLine: (text) ->
		return text.split newlineMatcher

	isEmpty: (text) ->
		return emptyLineMatcher.test text.trim()

	isComment: (text) ->
		return commentLineMatcher.test text.trim()

	isSectionHeader: (text) ->
		return sectionHeaderMatcher.test text.trim()

	getSectionHeader: (text) ->
		if not @isSectionHeader text
			return null
		else
			return text.trim().match(sectionHeaderMatcher)[1].trim()

	isKeyValue: (text) ->
		return keyValueMatcher.test text.trim()