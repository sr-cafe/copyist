Line = require '../lib/line'

describe 'Line class', ->
	it 'exposes expected API', ->
		[
			'raw'
			'content'
			'lineNumber'
			'components'
		].forEach (fn) ->
			expect(fn).toBeDefined()

	it 'throws an error when instantiated directly', ->
		test = ->
			new Line()
		expect(test).toThrow()