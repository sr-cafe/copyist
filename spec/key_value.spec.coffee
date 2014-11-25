KeyValue = require '../lib/key_value'

describe 'KeyValue', ->
	keyValue = null

	beforeEach ->
		keyValue = new KeyValue 'key = value for the line', 10

	it 'has a "KeyValue" type', ->
		expect(keyValue.getType()).toEqual 'KeyValue'

	it 'returns the correct line number', ->
		expect(keyValue.lineNumber()).toEqual 10

	it 'returns the value of the line', ->
		expect(keyValue.value()).toEqual 'value for the line'

	it 'returns the key of the line', ->
		expect(keyValue.key()).toEqual 'key'

	it 'returns the correct data', ->
		data =
			lineNumber: 10
			raw: 'key = value for the line'
			value: 'value for the line'
			key: 'key'
		expect(keyValue.data()).toEqual data