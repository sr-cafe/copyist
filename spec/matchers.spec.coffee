require 'jasmine-expect'

matchers = require '../lib/matchers'

describe 'Matchers smoke test', ->
	it 'exposes expected API', ->
		[
			'splitOnNewLine'
			'isEmpty'
			'isComment'
			'isSectionHeader'
			'isKeyValue'
		].forEach (fn) ->
			expect(matchers[fn]).toBeFunction()

describe 'Matchers API', ->
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
			'Also not a #coment'
			'[#Neither I am]'
		].forEach (text) ->
			test = matchers.isComment text
			expect(test).toBeFalse()

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
		].forEach (text) ->
			test = matchers.getSectionHeader text
			expect(test).toBeNull()

	it 'isKeyValue returns true for key=value strings', ->
		[
			'key=value'
			'	key = value'
			'key = a longer value	'
			'  key    = a value with an additional = inside...'
			'key.subkey = a nested key'
			'key.subkey.grand_subkey = value'
			'key.with.empty.value ='
		].forEach (text) ->
			test = matchers.isKeyValue text
			expect(test).toBeTrue()

	it 'isKeyValue returns false for non-section header strings', ->
		[
			'header'
			'#comment'
			'header]'
			'	[header'
			'#[header ]'
			'[header section]'
		].forEach (text) ->
			test = matchers.isSectionHeader text
			expect(test).toBeFalse()