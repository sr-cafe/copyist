Copyist = require '../lib/copyist'

describe 'Copyist', ->
	copyist = null

	beforeEach ->
		copyist = new Copyist()

	it 'converts key=value strings into an object', ->
		data = "#Starting comment.\n
					key=Value.\n
					another.key = And its value."

		expect(copyist.parse data).toEqual {
			key:'Value.'
			another:
				key:'And its value.'
		}

	it 'merges its results with a provided object', ->
		data = "#Starting comment.\n
					key=Value.\n
					another.key = And its value."
		result = {
			one: 1
			and:
				two: 2
		}

		expect(copyist.parse data, result).toEqual {
			one: 1,
			and:
				two: 2
			key:'Value.'
			another:
				key:'And its value.'
		}

	it 'creates an array with duplicated keys', ->
		data = "item.key=One\n
				item.key=Two"

		expect(copyist.parse data).toEqual {
			item:
				key:['One', 'Two']
		}