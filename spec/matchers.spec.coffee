require 'jasmine-expect'

matchers = require '../lib/matchers'

describe 'Matchers smoke test', ->
	it 'exposes expected API', ->
		[
			'splitOnNewLine'
			'isEmpty'
			'isComment'
			'getComment'
			'isCommand'
			'getCommand'
			'isSectionHeader'
			'getSectionHeader'
			'isKeyValue'
			'getKey'
			'getValue'
		].forEach (fn) ->
			expect(matchers[fn]).toBeFunction()

describe 'Empty matchers', ->
	it 'splits text in new lines characters', ->
		test = 'First line.\nSecond line.'

		result = matchers.splitOnNewLine test
		expect(result).toBeArray()
		expect(result[0]).toEqual 'First line.'
		expect(result[1]).toEqual 'Second line.'

	it 'isEmpty returns true for empty strings', ->
		test = matchers.isEmpty '     '
		expect(test).toBeTrue()

	it 'isEmpty returns false for non-empty strings', ->
		test = matchers.isEmpty '   a  '
		expect(test).toBeFalse()

describe 'Comment matchers', ->
	it 'isComment returns true for comment strings', ->
		[
			'# I am a comment'
			'  # Me too'
			'		#And so I am'
			'#[Me too]'
		].forEach (text) ->
			test = matchers.isComment text
			expect(test).toBeTrue()

	it 'isComment returns false for non-comment strings', ->
		[
			'Not a comment'
			'Also not a #comment'
			'[#Neither I am]'
		].forEach (text) ->
			test = matchers.isComment text
			expect(test).toBeFalse()

describe 'Command matchers', ->
	it 'isCommand returns true for command strings', ->
		[
			'!# I am a command'
			'  !# Me too'
			'		!#And so I am'
			'!#[Me !#too]'
		].forEach (text) ->
			test = matchers.isCommand text
			expect(test).toBeTrue()

	it 'isCommand returns false for non-command strings', ->
		[
			'!Not a command'
			'Also not a !#command'
			'[!#Neither I am]'
			'! # Nor me'
		].forEach (text) ->
			test = matchers.isCommand text
			expect(test).toBeFalse()

	it 'getCommand returns the value after !# in a command string', ->
		[
			'!#Command goes here'
			'!#       Command goes here'
			'		!#Command goes here'
		].forEach (text) ->
			test = matchers.getCommand text
			expect(test).toEqual 'Command goes here'

		[
			'!#Command !#goes here'
			'!#		Command !#goes here'
		].forEach (text) ->
			test = matchers.getCommand text
			expect(test).toEqual 'Command !#goes here'

	it 'getCommand returns null when feeded a non-command string', ->
		[
			'command'
			'#comment'
			'! # not a command'
			'a regular line'
			'a line with !# fake command'
		].forEach (text) ->
			test = matchers.getCommand text
			expect(test).toBeNull()

describe 'Section header matchers', ->
	it 'isSectionHeader returns true for section header strings', ->
		[
			'[header]'
			'	[header]'
			'[header]	'
			'[ header ]'
			'[	header]'
			'[header.section]'
			'[	header.section    ]'
			'[section2]'
		].forEach (text) ->
			test = matchers.isSectionHeader text
			expect(test).toBeTrue()

	it 'isSectionHeader returns false for non-section header strings', ->
		[
			'header'
			'#comment'
			'header]'
			'	[header'
			'#[header ]'
			'[header section]'
			'[]'
			'[ ]'
			'[1section]'
		].forEach (text) ->
			test = matchers.isSectionHeader text
			expect(test).toBeFalse()

	it 'getSectionHeader returns the value contained between [] in a section header string', ->
		[
			'[header]'
			'	[header]'
			'[header]	'
			'[ header ]'
			'[	header]'
		].forEach (text) ->
			test = matchers.getSectionHeader text
			expect(test).toEqual 'header'

		[
			'[header.section]'
			'[	header.section    ]'
		].forEach (text) ->
			test = matchers.getSectionHeader text
			expect(test).toEqual 'header.section'

	it 'getSectionHeader returns null when feeded a non-section header string', ->
		[
			'header'
			'#comment'
			'header]'
			'	[header'
			'#[header ]'
			'[header section]'
			'[1header]'
		].forEach (text) ->
			test = matchers.getSectionHeader text
			expect(test).toBeNull()

describe 'Key=value matchers', ->
	it 'isKeyValue returns true for key/value strings', ->
		[
			'key=value'
			'	key = value'
			'key = a longer value	'
			'  key    = a value with an additional = inside...'
			'key.subkey = a nested key'
			'key.subkey.grand_subkey = value'
			'key.subkey.and.a.very.long.list.of.nested.subkeys=value'
			'key.with.empty.value='
			'_key=value'
		].forEach (text) ->
			test = matchers.isKeyValue text
			expect(test).toBeTrue()

	it 'isKeyValue returns false for non-key/value strings', ->
		[
			'key'
			'1key=value'
			'.key=value'
			'key subkey = value'
			'key.sub-key=value'
			'$key=value'
		].forEach (text) ->
			test = matchers.isKeyValue text
			expect(test).toBeFalse()

	it 'getKey returns the key of a key/value string', ->
		[
			'key=value'
			'	key = value'
			'key = value with another = for testing purposes'
		].forEach (text) ->
			test = matchers.getKey text
			expect(test).toEqual 'key'

		[
			'key.subkey=value'
			'	key.subkey = value with another = for testing purposes and a key.subkey also inside...'
		].forEach (text) ->
			test = matchers.getKey text
			expect(test).toEqual 'key.subkey'

		[
			'key.subkey.and.a.very.long.list.of.nested.subkeys=value'
		].forEach (text) ->
			test = matchers.getKey text
			expect(test).toEqual 'key.subkey.and.a.very.long.list.of.nested.subkeys'

	it 'getKey returns null when feeded a non-key/value string', ->
		[
			'key'
			'1key=value'
			'.key=value'
			'key subkey = value'
			'key.sub-key=value'
			'$key=value'
		].forEach (text) ->
			test = matchers.getKey text
			expect(test).toBeNull()

	it 'getValue returns the value of a key/value string', ->
		[
			'key=value of the line'
			'	key = value of the line'
			'key = value of the line'
			'key.subkey = value of the line'
		].forEach (text) ->
			test = matchers.getValue text
			expect(test).toEqual 'value of the line'

		[
			'key=value with another = for testing purposes and a key.subkey also inside...'
			'	key.subkey = 		value with another = for testing purposes and a key.subkey also inside...'
		].forEach (text) ->
			test = matchers.getValue text
			expect(test).toEqual 'value with another = for testing purposes and a key.subkey also inside...'

		[
			'key='
			'key=       '
		].forEach (text) ->
			test = matchers.getValue text
			expect(test).toEqual ''

	it 'getValue returns null when feeded a non-key/value string', ->
		[
			'key'
			'1key=value'
			'.key=value'
			'key subkey = value'
			'key.sub-key=value'
			'$key=value'
		].forEach (text) ->
			test = matchers.getValue text
			expect(test).toBeNull()