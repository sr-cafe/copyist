Comment = require '../lib/comment'

describe 'Comment', ->
	comment = null

	beforeEach ->
		comment = new Comment '#Comment line', 1

	it 'has a "Comment" type', ->
		expect(comment.getType()).toEqual 'Comment'

	it 'returns the correct line number', ->
		expect(comment.lineNumber()).toEqual 1

	it 'returns the content of the line', ->
		expect(comment.value()).toEqual 'Comment line'

	it 'returns the correct data', ->
		data =
			lineNumber: 1
			raw: '#Comment line'
			value: 'Comment line'
		expect(comment.data()).toEqual data