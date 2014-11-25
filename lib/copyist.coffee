util = require 'util'

matchers = require './matchers'
CommandLine = require './command'
CommentLine = require './comment'
EmptyLine = require './empty'
KeyValueLine = require './key_value'

createLine = (line, index) ->
	if matchers.isEmpty line
		return new EmptyLine line, index

	if matchers.isCommand line
		return new CommandLine line, index

	if matchers.isComment line
		return new CommentLine line, index

	if matchers.isKeyValue line
		return new KeyValueLine line, index

	throw new Error "Unknown type for line number #{index + 1}: #{line}"

isKeyValueLine = (line) ->
	return line.getType() is 'KeyValue'

addLineToObject = (obj) ->
	return (line) ->
		keys = line.key().split '.'
		content = line.value()

		if keys.length is 1
			node = addNode obj, keys[0], content
		else
			leaf = obj
			for key in keys.splice 0, keys.length - 1
				if not leaf[key]
					leaf[key] = {}
				leaf = leaf[key]
			node = addNode leaf, keys[keys.length - 1], content

addNode = (node, key, content) ->
	if key of node
		isArr = util.isArray node[key]
		if not isArr
			node[key] = [node[key]]
		node[key].push content
	else
		node[key] = content
	return node

addKeyToObject = (keys, obj, content) ->
	if keys.length is 1
		obj[keys[0]] = {}
	key = keys.shift()

class Copyist
	constructor: () ->

	parse: (text, result) ->

		addLine = addLineToObject result ?= {}

		matchers.splitOnNewLine(text)
			.map(createLine)
			.filter(isKeyValueLine)
			.forEach addLine

		return result

module.exports = Copyist