class CyrToLat


	@checkArgs : ( args ) ->
		return false if args.dir is undefined


	@getExt : (filename) ->
		i = filename.lastIndexOf('.')
		#return (i<0) ? '' : filename.substr(i+1).toLowerCase()
		res = if i < 0 then '' else filename.substr(i+1).toLowerCase()


	@mapToLatin : (string) ->
		cyrMap = {
			'А': 'A',
			'а': 'a',
			'Б': 'B',
			'б': 'b',
			'В': 'V',
			'в': 'v',
			'Г': 'G',
			'г': 'g',
			'Д': 'D',
			'д': 'd',
			'Е': 'E',
			'е': 'e',
			'Ё': 'Jo',
			'ё': 'jo',
			'Ж': 'Zh',
			'ж': 'zh',
			'З': 'Z',
			'з': 'z',
			'И': 'I',
			'и': 'i',
			'Й': 'J',
			'й': 'j',
			'К': 'K',
			'к': 'k',
			'Л': 'L',
			'л': 'l',
			'М': 'M',
			'м': 'm',
			'Н': 'N',
			'н': 'n',
			'О': 'O',
			'о': 'o',
			'П': 'P',
			'п': 'p',
			'Р': 'R',
			'р': 'r',
			'С': 'S',
			'с': 's',
			'Т': 'T',
			'т': 't',
			'У': 'U',
			'у': 'u',
			'Ф': 'F',
			'ф': 'f',
			'Х': 'H',
			'х': 'h',
			'Ц': 'C',
			'ц': 'c',
			'Ч': 'Ch',
			'ч': 'ch',
			'Ш': 'Sh',
			'ш': 'sh',
			'Щ': 'Ssh',
			'щ': 'ssh',
			'Ъ': '#',
			'ъ': '#',
			'Ы': 'Y',
			'ы': 'y',
			'Ь': '"',
			'ь': '\'',
			'Э': 'Je',
			'э': 'je',
			'Ю': 'Ju',
			'ю': 'ju',
			'Я': 'Ja',
			'я': 'ja'
		};

		return string.split('').map( (char) ->
			cyrMap[char] || char
		).join("")



	@getIncFilename : ( path, type ) ->
		spath = path
		ext = null
		first = true

		if type is 'file'
			dotIdx = path.lastIndexOf('.')
			spath = path.substr('0', dotIdx )
			ext = path.substr(dotIdx)

		# check count
		openBrIdx = spath.lastIndexOf('(')
		closeBrIdx = spath.lastIndexOf(')')


		if openBrIdx isnt -1 and closeBrIdx is (spath.length - 1)
			count = parseInt( spath.substring( (openBrIdx+1), closeBrIdx ), 10)

			if typeof count is 'number' and count > 0
				count++
				path = path.substr(0, (openBrIdx+1) ) + count + ")"
				path += ext if ext isnt null
				first = false

		if first
			if ext isnt null
				path = path.substr(0, path.lastIndexOf('.')) + '(1)' + ext
			else
				path += '(1)'

		return path



exports.CyrToLat = CyrToLat
